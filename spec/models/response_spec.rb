RSpec.describe Response do
  describe "validations" do
    subject(:response) { FactoryBot.build(:response) }

    it "has a valid default factory" do
      expect(response).to be_valid
    end

    it "requires a value" do
      response.value = " "
      expect(response).to be_invalid
    end
  end

  describe ".newest_per_project_question" do
    it "returns the newest response for each project question" do
      project_question = FactoryBot.create(:project_question)
      another_question = FactoryBot.create(:project_question)

      r1  = FactoryBot.create(:response, created_at: 2.minutes.ago, project_question: project_question)
      _r2 = FactoryBot.create(:response, created_at: 3.minutes.ago, project_question: project_question)
      r3 = FactoryBot.create(:response, created_at: 4.minutes.ago, project_question: another_question)

      expect(Response.newest_per_project_question).to eq [r1, r3]
    end
  end
end
