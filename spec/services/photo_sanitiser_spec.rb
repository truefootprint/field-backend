RSpec.describe PhotoSanitiser do
  def create_response(**attributes)
    q = FactoryBot.create(:photo_upload_question)
    pq = FactoryBot.create(:project_question, question: q)

    FactoryBot.create(:response, project_question: pq, **attributes)
  end

  describe ".sanitise_json!" do
    it "removes sensitive information from the photos json" do
      photo_references = [{
        uri: "/field-app/user/chrispatuzzo/md5.jpg",
        width: 800,
        height: 600,
        exif: {
          "GPS Latitude": 123,
          "GPS Longitude": 456,
        },
      }].to_json

      record = create_response(value: photo_references)

      described_class.sanitise_json!(record, :value)
      sanitised = JSON.parse(record.reload.value, symbolize_names: true)

      expect(sanitised).to eq [{
        uri: "[[[documents]]]/md5.jpg", width: 800, height: 600,
      }]
    end

    it "does not touch updated_at if nothing has changed" do
      record = create_response(value: [].to_json, updated_at: "2020-01-01")
      described_class.sanitise_json!(record, :value)

      expect { described_class.sanitise_json!(record, :value) }
        .not_to change { record.reload.updated_at }
    end
  end
end
