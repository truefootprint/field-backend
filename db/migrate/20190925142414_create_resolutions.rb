class CreateResolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :resolutions do |t|
      t.belongs_to :issue
      t.belongs_to :user
      t.text :description
      t.timestamps
    end
  end
end
