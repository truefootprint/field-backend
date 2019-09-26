class AttachmentPresenter < ApplicationPresenter
  include Rails.application.routes.url_helpers

  def as_json(_options = {})
    if object.is_a?(ActiveStorage::Attached::Many)
      present_collection(object)
    else
      present(object)
    end
  end

  def present(record)
    { url: url_for(record) }
  end
end
