class ResolutionPresenter < ApplicationPresenter
  def present(record)
    { description: record.description }
      .merge(present_user(record))
      .merge(present_photos(record))
  end

  def present_user(record)
    present_nested(:user, UserPresenter) { record.user }
  end

  def present_photos(record)
    present_nested(:photos, AttachmentPresenter) { record.photos }
  end
end
