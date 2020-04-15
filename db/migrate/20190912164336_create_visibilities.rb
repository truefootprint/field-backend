class CreateVisibilities < ActiveRecord::Migration[6.0]
  def change
    create_table :visibilities do |t|
      t.belongs_to :subject, polymorphic: true
      t.belongs_to :visible_to, polymorphic: true
      t.timestamps
    end

    add_index :visibilities, %i[subject_type subject_id visible_to_type visible_to_id],
      name: "visibilities_index", unique: true
  end
end
