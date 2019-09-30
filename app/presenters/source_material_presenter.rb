class SourceMaterialPresenter < ApplicationPresenter
  def present(record)
    super.merge(present_document(record))
  end

  def present_document(record)
    present_nested(:document, DocumentPresenter) do
      record.document
    end
  end

  def options
    super.merge(document: true)
  end
end
