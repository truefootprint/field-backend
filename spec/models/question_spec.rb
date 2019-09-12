RSpec.describe Question do
  describe "validations" do
    subject(:question) { FactoryBot.build(:question) }

    it "has a valid default factory" do
      expect(question).to be_valid
    end

    it "requires text" do
      question.text = " "
      expect(question).to be_invalid
    end

    it "must be unique per topic/text" do
      existing = FactoryBot.create(:question)

      question.text = existing.text
      expect(question).to be_valid

      question.topic = existing.topic
      expect(question).to be_invalid

      question.text = "Something else"
      expect(question).to be_valid
    end
  end

  describe "#scoped_to_roles" do
    it "gets a relation of roles" do
      role = FactoryBot.create(:role)
      question = FactoryBot.build(:question, scoped_to_role_ids: [role.id])

      expect(question.scoped_to_roles).to be_a(ActiveRecord::Relation)
      expect(question.scoped_to_roles).to eq [role]
    end
  end

  describe "#scoped_to_roles=" do
    it "sets the scoped_to_roles_id column" do
      role = FactoryBot.create(:role)
      question = FactoryBot.build(:question, scoped_to_roles: [role])

      expect(question.scoped_to_role_ids).to eq [role.id]
    end

    it "raises if the roles aren't persisted" do
      role = FactoryBot.build(:role)

      expect { FactoryBot.build(:question, scoped_to_roles: [role]) }
        .to raise_error(/Roles must be persisted/)
    end
  end
end
