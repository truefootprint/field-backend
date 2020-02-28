RSpec.describe IssueNote do
  let(:issue_note) { FactoryBot.build(:issue_note) }

  describe "validations" do
    it "has a valid default factory" do
      expect(issue_note).to be_valid
    end

    it "requires either text or photos json" do
      issue_note.text = " "
      issue_note.photos_json = "[]"
      expect(issue_note).to be_invalid

      issue_note.text = "something"
      expect(issue_note).to be_valid

      issue_note.text = " "
      issue_note.photos_json = [{ uri: "image.jpg" }].to_json
      expect(issue_note).to be_valid
    end
  end

  it "defaults 'photos_json' to an empty array" do
    expect(issue_note.photos_json).to eq("[]")
  end

  it "defaults 'resolved' to false" do
    expect(issue_note.resolved).to eq(false)
  end
end
