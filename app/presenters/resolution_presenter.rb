class ResolutionPresenter < ApplicationPresenter
  def present(record)
    super
      .merge(present_user(record))
      .merge(present_versioned_content(record))
  end

  def present_user(record)
    present_nested(:user, UserPresenter) { record.user }
  end

  def present_versioned_content(record)
    present_nested(:versioned_content, VersionedContentPresenter) { record.versioned_contents.latest }
  end

  def options
    super.merge(versioned_content: { photos: true })
  end
end
