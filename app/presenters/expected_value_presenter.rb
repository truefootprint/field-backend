class ExpectedValuePresenter < ApplicationPresenter
  def present(record)
    super.merge(present_source_materials(record))
  end

  def present_source_materials(record)
    present_nested(:source_materials, SourceMaterialPresenter) do
      record.source_materials
    end
  end
end
