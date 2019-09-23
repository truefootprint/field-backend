class RemoveResponseTriggers < ActiveRecord::Migration[6.0]
  def change
    drop_table :response_triggers do |t|
      t.belongs_to :question
      t.text :value
      t.string :event_name
      t.json :event_params
      t.timestamps
    end
  end
end
