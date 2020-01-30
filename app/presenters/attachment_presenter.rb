class AttachmentPresenter < ApplicationPresenter
  include Rails.application.routes.url_helpers
  include Base64ToHex

  def as_json(_options = {})
    if object.is_a?(ActiveStorage::Attached::Many)
      present_collection(object)
    else
      present(object)
    end
  end

  def present(record)
    {
      url: url_for(record),
      name: record.filename,
      md5: base64_to_hex(record.checksum),
    }
  end
end
