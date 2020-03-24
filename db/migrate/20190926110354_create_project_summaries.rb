class CreateProjectSummaries < ActiveRecord::Migration[6.0]
  def change
    create_table :project_summaries do |t|
      t.belongs_to :project, index: { unique: true }
      t.jsonb :text, null: false, default: {}
      t.timestamps
    end
  end
end
