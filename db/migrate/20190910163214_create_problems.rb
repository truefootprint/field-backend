class CreateProblems < ActiveRecord::Migration[6.0]
  def change
    create_table :problems do |t|
      t.belongs_to :subject, polymorphic: true
      t.string :state
      t.timestamps
    end

    add_index :problems, :state
  end
end
