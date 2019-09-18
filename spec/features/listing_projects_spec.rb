RSpec.describe "Listing projects" do
  before do
    FactoryBot.create(:user, name: "Test") # TODO: authentication
    FactoryBot.create(:role, name: "Test")
  end

  let(:auth) { { name: "Test", role: "Test" } }

  scenario "listing all the projects, activities, questions, etc for a user" do
    get "/projects", auth

    expect(response.status).to eq(200)
    expect(parsed_json).to eq []
  end
end
