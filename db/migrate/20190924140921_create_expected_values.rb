class CreateExpectedValues < ActiveRecord::Migration[6.0]
  def change
    create_table :expected_values do |t|
      t.belongs_to :project_question, index: { unique: true }
      t.text :value, null: false
      t.timestamps
    end
  end
end
