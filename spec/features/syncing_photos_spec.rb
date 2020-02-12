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

  let(:admin_user) { FactoryBot.create(:user, name: "admin") }
  let(:admin_role) { FactoryBot.create(:role, name: "admin") }
  let(:admin_token) { ApiToken.generate_for!(admin_user) }

  before do
    FactoryBot.create(:user_role, user: admin_user, role: admin_role)
    user_role = FactoryBot.create(:user_role, user: user, role: role)

    [project, project_activity, project_question].each do |subject|
      FactoryBot.create(:visibility, subject: subject, visible_to: user_role)
    end

    allow(file).to receive(:original_filename).and_return("md5.jpg")

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
    # Add a response the references a photo.
    response_value = [{ uri: "/field-app/md5.jpg", width: 1920, height: 1080 }].to_json
    post_update(response_value)
    expect(response.status).to eq(201)

    # Check that the response is populated.
    get "/my_data"
    expect(response.status).to eq(200)
    photo_response = all_responses.first
    expect(photo_response.fetch(:value)).to be_present
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

  scenario "extracting exif metadata and santisting the photo uri" do
    response_value = [{
      uri: "/field-app/md5.jpg",
      width: 1920,
      height: 1080,
      exif: {
        "GPS Latitude": 123,
        "GPS Longitude": 456,
      },
    }].to_json

    # Add a response that contains sensitive exif metadata.
    post_update(response_value)
    expect(response.status).to eq(201)

    # Check that the exif data is removed and the uri is anonymised.
    get "/my_data"
    expect(response.status).to eq(200)
    json_value = all_responses.first.fetch(:value)
    value = JSON.parse(json_value, symbolize_names: true).first
    expect(value).to eq(uri: "<documents>/md5.jpg", width: 1920, height: 1080)

    # Upload the referenced photo after the response.
    post "/my_photos", image: file
    expect(response.status).to eq(201)

    # Log in as an admin and request the exif data resource.
    basic_authorize("", admin_token.token)
    get "/exif_data_sets?#{presentation(user: true, photos: true)}"
    expect(response.status).to eq(200)

    # Check the exif data been saved for the user and the photo is attached.
    resource = parsed_json.first
    exif_data = JSON.parse(resource.fetch(:data))
    expect(exif_data).to eq("GPS Latitude" => 123, "GPS Longitude" => 456)
    expect(resource.dig(:user, :name)).to eq("Test")
    expect(resource.fetch(:photos).size).to eq(1)
  end
end
