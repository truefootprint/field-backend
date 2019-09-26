class DocumentPresenter < ApplicationPresenter
  def present(record)
    present_nested(:file, AttachmentPresenter) { record.file }
  end

  def options
    super.merge(file: true)
  end
end
