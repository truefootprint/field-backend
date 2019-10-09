RSpec.describe SourceMaterial do
  describe "validations" do
    subject(:source_material) { FactoryBot.build(:source_material) }

    it "has a valid default factory" do
      expect(source_material).to be_valid
    end

    it "requires a natural number for page" do
      source_material.page = 1.5
      expect(source_material).to be_invalid

      source_material.page = 0
      expect(source_material).to be_invalid

      source_material.page = nil
      expect(source_material).to be_valid
    end

    it "requires a known subject type" do
      source_material.subject_type = "unknown"
      expect(source_material).to be_invalid
    end
  end
end
