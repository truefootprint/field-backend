RSpec.describe QueryParser do
  describe "#order" do
    it "returns _sort and _order as a hash" do
      parser = described_class.new(_sort: "id", _order: "desc")
      expect(parser.order).to eq("id" => "desc")
    end

    it "defaults _order to asc is blank" do
      parser = described_class.new(_sort: "id")
      expect(parser.order).to eq("id" => "asc")
    end

    it "returns nil if _sort is blank" do
      parser = described_class.new(_sort: " ")
      expect(parser.order).to be_nil
    end
  end

  describe "#offset" do
    it "returns the _start parameter as an integer" do
      parser = described_class.new(_start: "123")
      expect(parser.offset).to eq(123)
    end

    it "returns nil if _start is blank" do
      parser = described_class.new(_start: " ")
      expect(parser.offset).to be_nil
    end
  end

  describe "#limit" do
    it "returns the difference between _start and _end" do
      parser = described_class.new(_start: "20", _end: "50")
      expect(parser.limit).to eq(30)
    end

    it "returns _end if _start is blank" do
      parser = described_class.new(_start: " ", _end: "50")
      expect(parser.limit).to eq(50)
    end

    it "returns nil if _end is blank" do
      parser = described_class.new(_start: "20", _end: " ")
      expect(parser.limit).to be_nil
    end
  end
end
