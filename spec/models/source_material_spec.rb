RSpec.describe SourceMaterial do
  describe "validations" do
    subject(:source_material) { FactoryBot.build(:source_material) }

    it "has a valid default factory" do
      expect(source_material).to be_valid
    end
  end
end
