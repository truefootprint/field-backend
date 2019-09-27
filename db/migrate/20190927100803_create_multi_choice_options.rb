class CreateMultiChoiceOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :multi_choice_options do |t|
      t.belongs_to :question
      t.text :text
      t.integer :order
      t.timestamps
    end

    add_index :multi_choice_options, [:question_id, :text], unique: true
  end
end
