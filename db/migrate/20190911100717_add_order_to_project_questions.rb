class AddOrderToProjectQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :project_questions, :order, :integer
    add_index :project_questions, :order
  end
end
