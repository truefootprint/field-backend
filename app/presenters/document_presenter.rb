class DocumentPresenter < ApplicationPresenter
  def present(record)
    super.merge(present_attachment(record))
  end

  def present_attachment(record)
    present_nested(:file, AttachmentPresenter) { record.file }
  end

  def options
    super.merge(file: true)
  end
end
