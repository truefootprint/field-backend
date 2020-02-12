RSpec.describe PhotoMetadata do
  def create_response(**attributes)
    q = FactoryBot.create(:photo_upload_question)
    pq = FactoryBot.create(:project_question, question: q)

    FactoryBot.create(:response, project_question: pq, **attributes)
  end

  describe ".extract_exif_data!" do
    it "creates an exif data record" do
      exif = { "GPS Latitude" => 123, "GPS Longitude" => 456 }
      record = create_response(value: [{ uri: "uri/md5.jpg", exif: exif }].to_json)

      expect { described_class.extract_exif_data!(record) }
        .to change(ExifData, :count).by(1)

      exif_data = ExifData.last

      expect(exif_data.data).to eq(exif.to_json)
      expect(exif_data.filename).to eq("md5.jpg")
      expect(exif_data.user).to eq(record.user)
    end

    it "updates an existing exif data record if the filename matches" do
      FactoryBot.create(:exif_data, filename: "md5.jpg")

      exif = { "GPS Latitude" => "updated", "GPS Longitude" => "updated" }
      record = create_response(value: [{ uri: "uri/md5.jpg", exif: exif }].to_json)

      expect { described_class.extract_exif_data!(record) }
        .not_to change(ExifData, :count)

      exif_data = ExifData.last

      expect(exif_data.data).to eq(exif.to_json)
      expect(exif_data.filename).to eq("md5.jpg")
      expect(exif_data.user).to eq(record.user)
    end

    it "does not touch updated_at if nothing has changed" do
      exif_data = FactoryBot.create(:exif_data, filename: "md5.jpg", updated_at: "2020-01-01")

      record = create_response(
        user: exif_data.user,
        value: [{ uri: "uri/md5.jpg", exif: exif_data.parsed_data }].to_json,
      )

      expect { described_class.extract_exif_data!(record) }
        .not_to change { exif_data.reload.updated_at }
    end
  end
end
