class AddScopedToRoleIdsToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :scoped_to_role_ids, :integer, array: true
    add_index :questions, :scoped_to_role_ids
  end
end
