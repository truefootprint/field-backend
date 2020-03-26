class ExpectedValuePresenter < ApplicationPresenter
  def present(record)
    context = Interpolation::ExpectedValueContext.new(record)

    super
      .merge(text: context.apply(record.text))
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
