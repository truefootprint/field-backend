RSpec.describe PhotoAttachments do
  include FindOrCreateBlob

  def create_image_blob(filename)
    find_or_create_blob!(fixture_file_upload("files/#{filename}", "image/png"))
  end

  def create_response(**attributes)
    q = FactoryBot.create(:photo_upload_question)
    pq = FactoryBot.create(:project_question, question: q)

    FactoryBot.create(:response, project_question: pq, **attributes)
  end

  describe ".sync_record" do
    it "attaches image blobs that are referenced in the records's value" do
      create_image_blob("water-pump-stolen.png")

      image_references = [{ uri: "/documents/water-pump-stolen.png" }].to_json
      record = create_response(value: image_references)

      expect { PhotoAttachments.sync_record!(record) }
        .to change { record.reload.photos.count }.by(1)

      expect(record.photos.last.filename).to eq("water-pump-stolen.png")
    end

    it "does not attach the same blob more than once" do
      blob = create_image_blob("water-pump-stolen.png")

      image_references = [
        { uri: "/documents/water-pump-stolen.png" },
        { uri: "/documents/water-pump-stolen.png" },
      ].to_json

      record = create_response(value: image_references, photos: [])

      expect { PhotoAttachments.sync_record!(record) }
        .to change { record.reload.photos.count }.by(1)
    end

    it "detaches image blobs that are no longer referenced" do
      blob = create_image_blob("water-pump-stolen.png")
      record = create_response(value: [].to_json, photos: [blob])

      expect { PhotoAttachments.sync_record!(record) }
        .to change { record.reload.photos.count }.by(-1)

      expect(record.photos.count).to eq(0)
    end

    it "does not remove image blobs when they are detached" do
      blob = create_image_blob("water-pump-stolen.png")
      record = create_response(value: [].to_json, photos: [blob])

      expect { PhotoAttachments.sync_record!(record) }
        .not_to change(ActiveStorage::Blob, :count)
    end

    it "does nothing if the photo attachments are already in sync" do
      blob = create_image_blob("water-pump-stolen.png")

      image_references = [{ uri: "/documents/water-pump-stolen.png" }].to_json
      record = create_response(value: image_references, photos: [blob])

      expect { PhotoAttachments.sync_record!(record) }
        .not_to change { record.reload.photos.count }

      expect(record.photos.last.filename).to eq("water-pump-stolen.png")
    end

    it "does nothing if the record is for some other question type" do
      blob = create_image_blob("water-pump-stolen.png")
      record = create_response(value: [].to_json, photos: [blob])

      Question.last.update!(type: "FreeTextQuestion")

      expect { PhotoAttachments.sync_record!(record) }
        .not_to change { record.reload.photos.count }
    end

    it "does nothing if the record is orphaned from its question" do
      blob = create_image_blob("water-pump-stolen.png")
      record = create_response(value: [].to_json, photos: [blob])

      Question.last.destroy

      expect { PhotoAttachments.sync_record!(record) }
        .not_to change { record.reload.photos.count }
    end
  end

  describe ".sync_image" do
    it "attaches image blobs that are referenced in the response's value" do
      image = create_image_blob("water-pump-stolen.png")

      image_references = [{ uri: "/documents/water-pump-stolen.png" }].to_json
      response = create_response(value: image_references)

      expect { PhotoAttachments.sync_image!(image, response.user) }
        .to change { response.reload.photos.count }.by(1)

      expect(response.photos.last.filename).to eq("water-pump-stolen.png")
    end

    it "is scoped to the current user's responses" do
      another_user = FactoryBot.create(:user)
      image = create_image_blob("water-pump-stolen.png")

      image_references = [{ uri: "/documents/water-pump-stolen.png" }].to_json
      response = create_response(value: image_references)

      expect { PhotoAttachments.sync_image!(image, another_user) }
        .not_to change { response.reload.photos.count }
    end

    it "is scoped to responses for photo upload questions" do
      image = create_image_blob("water-pump-stolen.png")

      image_references = [{ uri: "/documents/water-pump-stolen.png" }].to_json
      response = create_response(value: image_references)

      Question.last.update!(type: "FreeTextQuestion")

      expect { PhotoAttachments.sync_image!(image, response.user) }
        .not_to change { response.reload.photos.count }
    end
  end
end
