class UnitPresenter < ApplicationPresenter
  def present(record)
    super.merge(plural: record.name.pluralize)
  end
end
