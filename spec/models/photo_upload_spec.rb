RSpec.describe PhotoUpload do
  describe "validations" do
    subject(:photo_upload) { FactoryBot.build(:photo_upload) }

    it "has a valid default factory" do
      expect(photo_upload).to be_valid
    end

    it "requires a photo" do
      photo_upload.photo = nil
      expect(photo_upload).to be_invalid
    end
  end
end
