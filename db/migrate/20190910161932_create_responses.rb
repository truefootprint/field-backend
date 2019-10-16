class CreateResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :responses do |t|
      t.belongs_to :project_question
      t.belongs_to :user
      t.belongs_to :unit, optional: true
      t.text :value, null: false
      t.timestamps
    end
  end
end
