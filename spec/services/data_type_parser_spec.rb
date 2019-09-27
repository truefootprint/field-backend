RSpec.describe DataTypeParser do
  specify { expect(described_class.parse("hello", "string")).to eq("hello") }

  specify { expect(described_class.parse("123", "number")).to eq(123) }
  specify { expect(described_class.parse("123.4", "number")).to eq(123.4) }

  specify { expect(described_class.parse("true", "boolean")).to eq(true) }
  specify { expect(described_class.parse("Y", "boolean")).to eq(true) }
  specify { expect(described_class.parse("yes", "boolean")).to eq(true) }
  specify { expect(described_class.parse("Pass", "boolean")).to eq(true) }

  specify { expect(described_class.parse("false", "boolean")).to eq(false) }
  specify { expect(described_class.parse("N", "boolean")).to eq(false) }
  specify { expect(described_class.parse("no", "boolean")).to eq(false) }
  specify { expect(described_class.parse("Fail", "boolean")).to eq(false) }

  pending "parse photo data types"

  it "raises an error if it doesn't know how to parse the data type" do
    expect { described_class.parse("hello", "unknown") }
      .to raise_error(ArgumentError, /unknown data type/i)
  end
end
