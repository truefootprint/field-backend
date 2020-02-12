module PhotoMetadata
  extend CreateOrUpdate

  def self.extract_exif_data!(record)
    return unless record.supports_photos?

    user = record.user

    record.photo_references.each do |r|
      next unless r.exif

      filename = File.basename(r.uri)

      where = { filename: filename }
      attributes = { user: user, filename: filename, data: r.exif.to_json }

      create_or_update!(ExifData, where: where, attributes: attributes)
    end
  end
end
