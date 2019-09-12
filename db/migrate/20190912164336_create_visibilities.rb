class CreateVisibilities < ActiveRecord::Migration[6.0]
  def change
    create_table :visibilities do |t|
      t.belongs_to :subject, polymorphic: true
      t.belongs_to :visible_to, polymorphic: true
      t.timestamps
    end
  end
end
