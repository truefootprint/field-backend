class VersionedContentPresenter < ApplicationPresenter
  def present(record)
    super.merge(present_photos(record))
  end

  def present_photos(record)
    present_nested(:photos, AttachmentPresenter) { record.photos }
  end
end
