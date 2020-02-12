module PhotoSanitiser
  def self.sanitise_json!(record, field)
    return unless record.supports_photos?

    references = record.photo_references.clone

    references.each do |r|
      r.uri = "<documents>/#{File.basename(r.uri)}"
      r.exif = nil
    end

    record.update!(field => references.to_json)
  end
end
