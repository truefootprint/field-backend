RSpec.describe ProjectQuestion do
  describe "validations" do
    subject(:project_question) { FactoryBot.build(:project_question) }

    it "has a valid default factory" do
      expect(project_question).to be_valid
    end

    it "requires an order" do
      project_question.order = nil
      expect(project_question).to be_invalid
    end
  end
end
