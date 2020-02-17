RSpec.describe VersionedContent do
  subject(:versioned_content) { FactoryBot.build(:versioned_content) }

  describe "validations" do
    it "has a valid default factory" do
      expect(versioned_content).to be_valid
    end

    it "requires content" do
      versioned_content.content = " "
      expect(versioned_content).to be_invalid
    end

    it "requires a known subject type" do
      versioned_content.subject_type = "unknown"
      expect(versioned_content).to be_invalid
    end

    it "requires the subject is set to the same as its ancestors" do
      parent = FactoryBot.create(:versioned_content)

      versioned_content.parent = parent
      versioned_content.subject = FactoryBot.create(:issue)

      expect(versioned_content).to be_invalid
    end

    it "requires the subject is set to the same as its descendants" do
      parent = FactoryBot.create(:versioned_content)
      child = FactoryBot.create(:versioned_content, parent: parent, subject: parent.subject)

      parent.subject = FactoryBot.create(:issue)

      expect(parent).to be_invalid
    end
  end

  it "defaults 'photos' to an empty json array" do
    expect(versioned_content.photos).to eq("[]")
  end
end