class ExpectedValuePresenter < ApplicationPresenter
  def present(record)
    super
      .merge(present_unit(record))
      .merge(present_source_materials(record))
  end

  def present_unit(record)
    present_nested(:unit, UnitPresenter) do
      record.unit
    end
  end

  def present_source_materials(record)
    present_nested(:source_materials, SourceMaterialPresenter) do
      record.source_materials
    end
  end
end
