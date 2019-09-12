class CreateInvolvements < ActiveRecord::Migration[6.0]
  def change
    create_table :involvements do |t|
      t.belongs_to :project_activity
      t.belongs_to :user
      t.string :kind
      t.timestamps
    end

    add_index :involvements, :kind
  end
end
