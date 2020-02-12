module PhotoAttachments
  def self.sync_response!(response)
    return unless response&.project_question&.question.is_a?(PhotoUploadQuestion)

    expected = filenames_from_value(response)
    actual = filenames_from_attachments(response)

    additions = expected - actual
    deletions = actual - expected

    additions.each do |filename|
      blob = ActiveStorage::Blob.find_by(filename: filename)
      response.photos.attach(blob) if blob
    end

    deletions.each do |filename|
      response.photos.detect { |p| p.blob.filename.to_s == filename }.destroy
    end
  end

  def self.sync_image!(image, user)
    filename = image.filename.to_s

    user.responses
      .joins(project_question: :question)
      .merge(PhotoUploadQuestion.all)
      .where("value like ?", "%#{filename}%")
      .each { |r| sync_response!(r) }
  end

  private

  def self.filenames_from_attachments(response)
    response.photos.map { |attachment| attachment.blob.filename.to_s }
  end

  def self.filenames_from_value(response)
    JSON.parse(response.value).map { |img| File.basename(img.fetch("uri")) }
  end
end
