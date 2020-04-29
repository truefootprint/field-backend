class ChangeRolesController < ApplicationController
  def create
    access_denied and return unless old_role
    access_denied and return unless new_role.user_selectable?

    registration.update!(project_role: new_role)
  end

  private

  def new_role
    @new_role ||= ProjectRole.find(params.fetch(:id))
  end

  def old_role
    @old_role ||= current_user.project_roles.detect { |pr| pr.project == new_role.project }
  end

  def registration
    @registration ||= Registration.find_by!(project_role: old_role, user: current_user)
  end
end
