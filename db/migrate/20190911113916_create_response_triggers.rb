class CreateResponseTriggers < ActiveRecord::Migration[6.0]
  def change
    create_table :response_triggers do |t|
      t.belongs_to :question
      t.text :value
      t.string :event_name
      t.json :event_params
      t.timestamps
    end

    add_index :response_triggers, :event_name
  end
end
