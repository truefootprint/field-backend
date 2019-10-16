RSpec.describe Unit do
  describe "validations" do
    subject(:unit) { FactoryBot.build(:unit) }

    it "has a valid default factory" do
      expect(unit).to be_valid
    end

    it "requires a name" do
      unit.name = " "
      expect(unit).to be_invalid
    end

    it "requires a unique name" do
      FactoryBot.create(:unit, name: "meter")

      unit.name = "meter"
      expect(unit).to be_invalid
    end

    it "requires a name recognised by the Unitwise gem" do
      unit.name = "unknown"
      expect(unit).to be_invalid
    end

    it "requires a known type" do
      unit.type = "unknown"
      expect(unit).to be_invalid
    end

    it "requires a type that matches the Unitwise property" do
      unit.name = "meter"
      unit.type = "weight"

      expect(unit).to be_invalid
    end
  end

  describe ".available_types" do
    it "returns all Unitwise properties" do
      types = Unit.available_types

      expect(types.size).to be >= 100
      expect(types).to include("force", "pressure")
    end

    it "sets TYPES to a subset of the available types" do
      expect(Unit::TYPES - Unit.available_types).to be_empty
    end
  end
end
