class CreateMultiChoiceOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :multi_choice_options do |t|
      t.belongs_to :question
      t.text :text, null: false
      t.integer :order, null: false
      t.timestamps
    end

    add_index :multi_choice_options, [:question_id, :text], unique: true
    add_index :multi_choice_options, :order
  end
end
