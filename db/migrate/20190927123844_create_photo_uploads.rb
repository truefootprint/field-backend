class CreatePhotoUploads < ActiveRecord::Migration[6.0]
  def change
    create_table :photo_uploads do |t|
      t.belongs_to :response
      t.timestamps
    end
  end
end
