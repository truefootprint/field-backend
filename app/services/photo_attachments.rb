module PhotoAttachments
  def self.sync_response!(response)
    return unless response&.project_question&.question.is_a?(PhotoUploadQuestion)

    expected = filenames_from_value(response)
    actual = filenames_from_attachments(response)

    delta = Delta.new(from: actual, to: expected, identifiers: [:itself])

    delta.additions.each do |filename|
      blob = ActiveStorage::Blob.find_by(filename: filename)
      response.photos.attach(blob) if blob
    end

    delta.deletions.each do |filename|
      response.photos.detect { |p| p.blob.filename.to_s == filename }.destroy
    end
  end

  def self.sync_image(image, user)
    # TODO
  end

  private

  def self.filenames_from_attachments(response)
    response.photos.map { |attachment| attachment.blob.filename.to_s }
  end

  def self.filenames_from_value(response)
    JSON.parse(response.value).map { |img| File.basename(img.fetch("uri")) }
  end
end
