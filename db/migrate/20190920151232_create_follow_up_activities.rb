class CreateFollowUpActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :follow_up_activities do |t|
      t.belongs_to :activity
      t.belongs_to :follow_up_activity
      t.timestamps
    end
  end
end
