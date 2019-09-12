class RenameEventNameToEventClass < ActiveRecord::Migration[6.0]
  def change
    rename_column :response_triggers, :event_name, :event_class
  end
end
