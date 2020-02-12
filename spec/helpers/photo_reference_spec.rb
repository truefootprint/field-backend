RSpec.describe PhotoReference do
  it "parses a json array of references to photos" do
    json_array = [{ uri: "uri-1", width: 123, height: 456 }, { uri: "uri-2" } ].to_json
    photo_references = described_class.parse_json_array(json_array)

    expect(photo_references.size).to eq(2)
    first, second = photo_references

    expect(first.uri).to eq("uri-1")
    expect(first.width).to eq(123)
    expect(first.height).to eq(456)

    expect(second.uri).to eq("uri-2")
    expect(second.width).to be_nil
    expect(second.width).to be_nil
  end

  it "returns an empty array for invalid json" do
    expect(described_class.parse_json_array("invalid")).to eq []
  end
end
