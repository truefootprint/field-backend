RSpec.describe ExifData do
  describe "validations" do
    subject(:exif_data) { FactoryBot.build(:exif_data) }

    it "has a valid default factory" do
      expect(exif_data).to be_valid
    end

    it "requires a user" do
      exif_data.user = nil
      expect(exif_data).to be_invalid
    end

    it "requires a filename" do
      exif_data.filename = " "
      expect(exif_data).to be_invalid
    end

    it "requires a unique filename" do
      FactoryBot.create(:exif_data, filename: "md5.jpg")

      exif_data.filename = "md5.jpg"
      expect(exif_data).to be_invalid
    end

    it "requires data" do
      exif_data.data = " "
      expect(exif_data).to be_invalid
    end

    it "requires json data" do
      exif_data.data = "invalid"
      expect(exif_data).to be_invalid
    end
  end
end
