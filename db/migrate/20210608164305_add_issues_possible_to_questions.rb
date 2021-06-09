class AddIssuesPossibleToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :issues_possible, :boolean, default: true
  end
end
