RSpec.describe PhotoUploadQuestion do
  describe "validations" do
    subject(:photo_upload_question) { FactoryBot.build(:photo_upload_question) }

    it "has a valid default factory" do
      expect(photo_upload_question).to be_valid
    end

    it "requires the data_type to be 'photo'" do
      photo_upload_question.data_type = "string"
      expect(photo_upload_question).to be_invalid
    end
  end
end
