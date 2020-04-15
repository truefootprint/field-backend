class CreateDefaultVisibilities < ActiveRecord::Migration[6.0]
  def change
    create_table :default_visibilities do |t|
      t.belongs_to :subject, polymorphic: true
      t.belongs_to :role
      t.timestamps
    end
  end
end
