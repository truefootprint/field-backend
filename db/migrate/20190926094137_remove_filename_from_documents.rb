class RemoveFilenameFromDocuments < ActiveRecord::Migration[6.0]
  def change
    remove_index :documents, :filename
    remove_column :documents, :filename, :text
  end
end
