RSpec.describe "Sync'ing photos" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Test") }
  let(:api_token) { FactoryBot.create(:api_token, user: user) }

  let(:photo) { file_fixture("water-pump-working.png") }
  let(:file) { Rack::Test::UploadedFile.new(photo) }

  let(:question) { FactoryBot.create(:photo_upload_question) }
  let(:project_question) { FactoryBot.create(:project_question, question: question) }
  let(:project_activity) { project_question.project_activity }
  let(:project) { project_activity.project }

  before do
    user_role = FactoryBot.create(:user_role, user: user, role: role)

    [project, project_activity, project_question].each do |subject|
      FactoryBot.create(:visibility, subject: subject, visible_to: user_role)
    end

    authenticate_as(user)
  end

  def post_update(response_value)
    post "/my_updates", updates: [{
      period_start: "2020-01-01T00:00:00.000Z",
      period_end:  "2020-01-01T23:59:59.000Z",
      responses: [
        created_at: "2020-01-01T12:00:00.000Z",
        updated_at: "2020-01-01T13:00:00.000Z",
        project_question_id: project_question.id,
        value: response_value,
      ],
    }]
  end

  scenario "synchronises response values with photos that are uploaded later" do
    allow(file).to receive(:original_filename).and_return("md5.jpg")

    # Add a response the references a photo.
    response_value = [{ uri: "/field-app/md5.jpg", width: 1920, height: 1080 }].to_json
    post_update(response_value)
    expect(response.status).to eq(201)

    # Check that the response is populated.
    get "/my_data"
    expect(response.status).to eq(200)
    photo_response = all_responses.first
    expect(photo_response.fetch(:value)).to eq(response_value)
    expect(photo_response.fetch(:photos)).to eq([])

    # Upload the referenced photo after the response.
    post "/my_photos", image: file
    expect(response.status).to eq(201)

    # Check that it has attached the photo to the response.
    get "/my_data"
    expect(response.status).to eq(200)
    photo_response = all_responses.first
    expect(photo_response.fetch(:photos)).to match_array(hash_including(
      name: "md5.jpg",
      md5: "bd00c7bcb4550512146c27dc092aa909",
      url: a_string_ending_with("/md5.jpg"),
    ))

    # Update the response so it no longer references the photo.
    post_update([].to_json)
    expect(response.status).to eq(201)

    # Check that it has detached the photo from the response.
    get "/my_data"
    expect(response.status).to eq(200)
    photo_response = all_responses.first
    expect(photo_response.fetch(:photos)).to be_empty

    # Update the response to reference the photo again.
    post_update(response_value)
    expect(response.status).to eq(201)

    # Check that it has re-attached the photo to the response.
    get "/my_data"
    expect(response.status).to eq(200)
    photo_response = all_responses.first
    expect(photo_response.fetch(:photos)).to match_array(hash_including(
      name: "md5.jpg",
      md5: "bd00c7bcb4550512146c27dc092aa909",
      url: a_string_ending_with("/md5.jpg"),
    ))
  end
end
