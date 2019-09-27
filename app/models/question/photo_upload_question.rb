class PhotoUploadQuestion < Question
  validates :data_type, inclusion: { in: %w[photo] }
end
