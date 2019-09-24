class CreateExpectedValues < ActiveRecord::Migration[6.0]
  def change
    create_table :expected_values do |t|
      t.belongs_to :project_question
      t.text :value
      t.timestamps
    end
  end
end
