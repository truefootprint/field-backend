RSpec.describe "Creating responses on behalf of a user" do
  let(:project_question) { FactoryBot.create(:project_question) }

  before do
    FactoryBot.create(:user, name: "Test") # TODO: authentication
    FactoryBot.create(:role, name: "Test")
  end

  let(:auth) { { name: "Test", role: "Test" } }

  scenario "" do
    params = {
      responses: [
        { question_id: project_question.id, value: "yes" },
      ]
    }

    post "/responses/batch", params.merge(auth)

    expect(response.status).to eq(201)
  end
end
