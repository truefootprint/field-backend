RSpec.describe "Source material management" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Admin") }

  let(:auth) { { user_name: "Test", role_name: "Admin" } }

  let(:contract) { file_fixture("water-pump-contract.pdf") }
  let(:file) { Rack::Test::UploadedFile.new(contract) }

  let(:document_id) do
    post "/documents", file: file; parsed_json.fetch(:id)
  end

  let(:programme_id) do
    post "/programmes", name: "Programme name", description: "Description"
    parsed_json.fetch(:id)
  end

  scenario "provides API endpoints to manage source materials" do
    get "/source_materials", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []

    post "/source_materials", auth.merge(
      subject_type: "Programme",
      subject_id: programme_id,
      document_id: document_id,
    )
    expect(response.status).to eq(201)

    post "/source_materials", subject_type: "Programme", subject_id: programme_id
    expect(response.status).to eq(422)
    expect(error_messages).to include("Document must exist")

    post "/source_materials", auth.merge(
      subject_type: "Programme",
      subject_id: programme_id,
      document_id: document_id,
      page: 123,
    )
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    get "/source_materials", auth
    expect(parsed_json.size).to eq(2)

    get "/source_materials", page: 123
    expect(parsed_json.size).to eq(1)

    get "/source_materials/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(page: 123)

    delete "/source_materials/#{id}", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to include(page: 123)

    get "/source_materials/#{id}", auth
    expect(response.status).to eq(404)

    delete "/source_materials/#{id}", auth
    expect(response.status).to eq(404)

    get "/source_materials", auth
    expect(response.status).to eq(200)
    expect(parsed_json).to match [
      hash_including(page: nil),
    ]

    id = parsed_json.first.fetch(:id)

    put "/source_materials/#{id}", page: 456
    expect(response.status).to eq(200)
    expect(parsed_json).to include(page: 456)

    put "/source_materials/#{id}", page: 0
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["Page must be greater than 0"]
  end
end
