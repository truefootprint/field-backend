class CreateSourceMaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :source_materials do |t|
      t.belongs_to :subject, polymorphic: true
      t.belongs_to :document
      t.integer :page
      t.timestamps
    end
  end
end
