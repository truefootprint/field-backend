class CreateDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :documents do |t|
      t.text :filename
      t.timestamps
    end

    add_index :documents, :filename
  end
end
