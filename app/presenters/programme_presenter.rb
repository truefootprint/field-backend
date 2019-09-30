class ProgrammePresenter < ApplicationPresenter
  def present(record)
    { id: record.id, name: record.name, description: record.description }
  end
end
