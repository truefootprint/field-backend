class CreateExifDataSets < ActiveRecord::Migration[6.0]
  def change
    create_table :exif_data_sets do |t|
      t.belongs_to :user
      t.string :filename, null: false
      t.jsonb :data, null: false
      t.timestamps
    end

    add_index :exif_data_sets, :filename, unique: true
  end
end
