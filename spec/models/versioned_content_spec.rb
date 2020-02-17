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
  end

  it "defaults 'photos' to an empty json array" do
    expect(versioned_content.photos).to eq("[]")
  end
end
