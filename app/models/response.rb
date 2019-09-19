class Response < ApplicationRecord
  belongs_to :project_question
  belongs_to :user

  delegate :question, :project, :project_type, to: :project_question

  validates :value, presence: true

  def self.newest_per_project_question
    result = connection.execute(<<~SQL)
      select distinct on ("project_question_id") id from responses
      order by "project_question_id", created_at desc
    SQL

    ids = result.map { |row| row.fetch("id") }

    Response.where(id: ids)
  end
end
