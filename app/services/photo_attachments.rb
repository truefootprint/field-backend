module PhotoAttachments
  def self.sync_record!(record)
    return unless record.supports_photos?

    expected = referenced_filenames(record)
    actual = attachment_filenames(record)

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

    user.issue_notes
      .where("photos_json like ?", "%#{filename}%")
      .each { |r| sync_record!(r) }

    user.exif_data_sets
      .where(filename: filename)
      .each { |r| sync_record!(r) }
  end

  private

  def self.attachment_filenames(record)
    record.photos.map { |attachment| attachment.blob.filename.to_s }
  end

  def self.referenced_filenames(record)
    record.photo_references.map { |r| File.basename(r.uri) }
  end
end
