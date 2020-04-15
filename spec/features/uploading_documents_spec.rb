RSpec.describe "Uploading documents" do
  let(:user) { FactoryBot.create(:user, name: "admin") }
  let(:role) { FactoryBot.create(:role, name: "admin") }
  let(:api_token) { FactoryBot.create(:api_token, user: user) }

  let(:contract) { file_fixture("water-pump-contract.pdf") }
  let(:evidence) { file_fixture("water-pump-stolen.png") }

  let(:file1) { Rack::Test::UploadedFile.new(contract) }
  let(:file2) { Rack::Test::UploadedFile.new(evidence) }

  before do
    project_role = FactoryBot.create(:project_role, role: role)
    FactoryBot.create(:registration, project_role: project_role, user: user)

    basic_authorize("", api_token.token)
  end

  scenario "provides API endpoints to upload documents" do
    get "/documents"
    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
    expect(response.headers.fetch("X-Total-Count")).to eq(0)

    post "/documents", file: file1
    expect(response.status).to eq(201)

    post "/documents"
    expect(response.status).to eq(422)
    expect(error_messages).to include("File can't be blank")

    post "/documents", file: file2
    expect(response.status).to eq(201)
    id = parsed_json.fetch(:id)

    # Filtering is not supported.

    get "/documents/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json.dig(:file, :url)).to include("stolen.png")

    delete "/documents/#{id}"
    expect(response.status).to eq(200)
    expect(parsed_json.dig(:file, :url)).to include("stolen.png")

    get "/documents/#{id}"
    expect(response.status).to eq(404)

    delete "/documents/#{id}"
    expect(response.status).to eq(404)

    get "/documents"
    expect(response.status).to eq(200)
    expect(parsed_json.size).to eq(1)
    expect(parsed_json.first.dig(:file, :url)).to include("contract.pdf")

    id = parsed_json.first.fetch(:id)

    put "/documents/#{id}", file: file2
    expect(response.status).to eq(200)
    expect(parsed_json.dig(:file, :url)).to include("stolen.png")

    put "/documents/#{id}", file: nil
    expect(response.status).to eq(422)
    expect(error_messages).to eq ["File can't be blank"]
  end

  scenario "only allows admins to access this resource" do
    role.update!(name: "monitor")

    get "/documents"
    expect(response.status).to eq(401)
  end
end
