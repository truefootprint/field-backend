class RemoveScopeFromUserRoles < ActiveRecord::Migration[6.0]
  def change
    remove_reference :user_roles, :scope, polymorphic: true, index: true
  end
end
