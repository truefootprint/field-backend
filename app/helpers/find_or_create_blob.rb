# TODO: When we upgrade to a newer version of Rails, we can create blobs
# without having to re-compute byte_size and checksum with this code:
#
# byte_size = uploaded_file.size
# filename = uploaded_file.original_filename
# md5 = filename.split(".").first
# checksum = [[md5].pack("H*")].pack("m0")

module FindOrCreateBlob
  def find_or_create_blob!(uploaded_file)
    filename = uploaded_file.original_filename

    record = ActiveStorage::Blob.find_by(filename: filename)
    return record if record

    ActiveStorage::Blob.create_and_upload!(
      io: uploaded_file,
      filename: filename,
      content_type: uploaded_file.content_type,
      identify: false,
    )

    # TODO: We could #analyze the blob to get metadata such as image dimensions,
    # but we'd need to install a gem like mini_magick. We don't need this yet.
  end
end
