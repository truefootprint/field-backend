module PhotoAttachments
  def self.sync_record!(record, field: :value)
    return unless record.supports_photos?

    expected = filenames_from_field(record, field)
    actual = filenames_from_attachments(record)

    additions = expected - actual
    deletions = actual - expected

    additions.each do |filename|
      blob = ActiveStorage::Blob.find_by(filename: filename)
      record.photos.attach(blob) if blob
    end

    deletions.each do |filename|
      record.photos.detect { |p| p.blob.filename.to_s == filename }.destroy
    end
  end

  def self.sync_image!(image, user)
    filename = image.filename.to_s

    user.responses
      .joins(project_question: :question)
      .merge(PhotoUploadQuestion.all)
      .where("value like ?", "%#{filename}%")
      .each { |r| sync_record!(r) }
  end

  private

  def self.filenames_from_attachments(record)
    record.photos.map { |attachment| attachment.blob.filename.to_s }
  end

  def self.filenames_from_field(record, field)
    JSON.parse(record.public_send(field)).map { |img| File.basename(img.fetch("uri")) }
  end
end
