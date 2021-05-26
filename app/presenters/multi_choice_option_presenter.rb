class MultiChoiceOptionPresenter < ApplicationPresenter
  def modify_scope(scope)
    scope.order(:order)
  end

  def present(record)
    if record.photo.attached?
     result = record.attributes.merge({photo: Rails.application.routes.url_helpers.rails_blob_path(record.photo)}).symbolize_keys  
    else
     result = record.attributes
    end
    result
  end
end
