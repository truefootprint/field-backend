class CreateDefaultExpectedValues < ActiveRecord::Migration[6.0]
  def change
    create_table :default_expected_values do |t|
      t.belongs_to :question
      t.belongs_to :activity, optional: true
      t.text :value, null: false
      t.timestamps
    end
  end
end
