class CreateProjectSummaries < ActiveRecord::Migration[6.0]
  def change
    create_table :project_summaries do |t|
      t.belongs_to :project
      t.text :text, null: false
      t.timestamps
    end
  end
end
