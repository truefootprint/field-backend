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

  context "for 'photo' data types" do
    let!(:photo_upload) { FactoryBot.create(:photo_upload) }

    it "looks up the photo upload record by id using the response's value" do
      expect(described_class.parse(photo_upload.id.to_s, "photo")).to eq(photo_upload)
    end

    it "errors if the response's value does not look like an id" do
      expect { described_class.parse("invalid", "photo") }.to raise_error(/invalid value/)
    end

    it "errors if the photo_upload doesn't exist" do
      expect { described_class.parse("999", "photo") }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "errors if the response's value doesn't match the photo_upload's response_id" do
      q = FactoryBot.create(:photo_upload_question)
      pq = FactoryBot.create(:project_question, question: q)
      r = FactoryBot.create(:response, value: photo_upload.id, project_question: pq)

      expect { described_class.parse_response(r) }
        .to raise_error(DataIntegrityError, /out of sync/)
    end
  end

  it "raises an error if it doesn't know how to parse the data type" do
    expect { described_class.parse("hello", "unknown") }
      .to raise_error(ArgumentError, /unknown data type/i)
  end
end
