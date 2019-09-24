class RemoveKindFromInvolvements < ActiveRecord::Migration[6.0]
  def change
    remove_index :involvements, :kind
    remove_column :involvements, :kind, :string
  end
end
