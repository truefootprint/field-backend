class IssuePresenter < ApplicationPresenter
  def present(record)
    super
      .merge(present_user(record))
      .merge(present_photos(record))
      .merge(present_resolution(record))
  end

  def present_user(record)
    present_nested(:user, UserPresenter) { record.user }
  end

  def present_photos(record)
    present_nested(:photos, AttachmentPresenter) { record.photos }
  end

  def present_resolution(record)
    present_nested(:resolution, ResolutionPresenter) { record.resolution }
  end
end
