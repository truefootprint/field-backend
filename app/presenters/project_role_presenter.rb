class ProjectRolePresenter < ApplicationPresenter
  def present(record)
    options[:simplified] ? present_simplified(record) : super
  end

  def present_simplified(record)
    { id: record.id, name: record.role.name }
  end
end
