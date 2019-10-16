class ResponsePresenter < ApplicationPresenter
  def present(record)
    super
      .merge(present_unit(record))
      .merge(present_photo(record))
  end

  def modify_scope(scope)
    scope.order(created_at: :desc)
  end

  def present_unit(record)
    present_nested(:unit, UnitPresenter) do
      record.unit
    end
  end

  def present_photo(record)
    present_nested(:photo, AttachmentPresenter) do
      record.photo.attached? && record.photo
    end
  end
end
