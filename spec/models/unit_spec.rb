RSpec.describe Unit do
  describe "validations" do
    subject(:unit) { FactoryBot.build(:unit) }

    it "has a valid default factory" do
      expect(unit).to be_valid
    end

    it "requires a singular" do
      unit.singular = " "
      expect(unit).to be_invalid
    end

    it "requires a plural" do
      unit.plural = " "
      expect(unit).to be_invalid
    end

    it "requires an official name" do
      unit.official_name = " "
      expect(unit).to be_invalid
    end

    it "requires a unique official name" do
      FactoryBot.create(:unit, official_name: "meter")

      unit.official_name = "meter"
      expect(unit).to be_invalid
    end

    it "requires an official name recognised by the Unitwise gem" do
      unit.official_name = "unknown"
      expect(unit).to be_invalid
    end

    it "requires a known type" do
      unit.type = "unknown"
      expect(unit).to be_invalid
    end

    it "requires a type that matches the Unitwise property" do
      unit.official_name = "meter"
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
