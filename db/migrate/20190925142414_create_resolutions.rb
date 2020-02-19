class CreateResolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :resolutions do |t|
      t.belongs_to :issue
      t.belongs_to :user
      t.belongs_to :created_at_issue_content_version
      t.timestamps
    end
  end
end
