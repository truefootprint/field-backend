class ExpectedValuePresenter < ApplicationPresenter
  def present(record)
    super
      .merge(present_text(record))
      .merge(present_unit(record))
      .merge(present_source_materials(record))
  end

  def present_text(record)
    return {} unless options[:interpolate]

    context = Interpolation::ExpectedValueContext.new(record)
    { text: context.apply(record.text) }
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
