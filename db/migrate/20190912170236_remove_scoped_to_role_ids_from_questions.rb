class RemoveScopedToRoleIdsFromQuestions < ActiveRecord::Migration[6.0]
  def change
    remove_index :questions, :scoped_to_role_ids
    remove_column :questions, :scoped_to_role_ids, :integer, array: true
  end
end
