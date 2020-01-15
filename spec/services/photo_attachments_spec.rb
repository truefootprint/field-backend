RSpec.describe PhotoAttachments do
  include FindOrCreateBlob

  def create_image_blob(filename)
    find_or_create_blob!(fixture_file_upload("files/#{filename}", "image/png"))
  end

  def create_photo_response(**attributes)
    q = FactoryBot.create(:photo_upload_question)
    pq = FactoryBot.create(:project_question, question: q)

    FactoryBot.create(:response, project_question: pq, **attributes)
  end

  describe ".sync_response" do
    it "attaches image blobs that are referenced in the response's value" do
      create_image_blob("water-pump-stolen.png")

      image_references = [{ uri: "/documents/water-pump-stolen.png" }].to_json
      response = create_photo_response(value: image_references)

      expect { PhotoAttachments.sync_response!(response) }
        .to change { response.reload.photos.count }.by(1)

      expect(response.photos.last.filename).to eq("water-pump-stolen.png")
    end

    it "detaches image blobs that are no longer referenced" do
      blob = create_image_blob("water-pump-stolen.png")
      response = create_photo_response(value: [].to_json, photos: [blob])

      expect { PhotoAttachments.sync_response!(response) }
        .to change { response.reload.photos.count }.by(-1)

      expect(response.photos.count).to eq(0)
    end

    it "does not remove image blobs when they are detached" do
      blob = create_image_blob("water-pump-stolen.png")
      response = create_photo_response(value: [].to_json, photos: [blob])

      expect { PhotoAttachments.sync_response!(response) }
        .not_to change(ActiveStorage::Blob, :count)
    end

    it "does nothing if the photo attachments are already in sync" do
      blob = create_image_blob("water-pump-stolen.png")

      image_references = [{ uri: "/documents/water-pump-stolen.png" }].to_json
      response = create_photo_response(value: image_references, photos: [blob])

      expect { PhotoAttachments.sync_response!(response) }
        .not_to change { response.reload.photos.count }

      expect(response.photos.last.filename).to eq("water-pump-stolen.png")
    end

    it "does nothing if the response is for some other question type" do
      blob = create_image_blob("water-pump-stolen.png")
      response = create_photo_response(value: [].to_json, photos: [blob])

      Question.last.update!(type: "FreeTextQuestion")

      expect { PhotoAttachments.sync_response!(response) }
        .not_to change { response.reload.photos.count }
    end

    it "does nothing if the response is orphaned from its question" do
      blob = create_image_blob("water-pump-stolen.png")
      response = create_photo_response(value: [].to_json, photos: [blob])

      Question.last.destroy

      expect { PhotoAttachments.sync_response!(response) }
        .not_to change { response.reload.photos.count }
    end
  end

  describe ".sync_image" do
    # TODO
  end
end
