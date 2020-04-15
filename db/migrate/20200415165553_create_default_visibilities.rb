class CreateDefaultVisibilities < ActiveRecord::Migration[6.0]
  def change
    create_table :default_visibilities do |t|
      t.belongs_to :subject, polymorphic: true
      t.belongs_to :role
      t.timestamps
    end

    add_index :default_visibilities, %i[subject_type subject_id role_id],
      name: "default_visibilities_index", unique: true
  end
end
