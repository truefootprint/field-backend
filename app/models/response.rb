class Response < ApplicationRecord
  belongs_to :project_question
  belongs_to :user
  belongs_to :unit, optional: true

  has_many_attached :photos, dependent: :destroy

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

  def question_id
    project_question.question_id
  end

  def parsed_value
    DataTypeParser.parse_response(self)
  end

  def supports_photos?
    project_question&.question.is_a?(PhotoUploadQuestion)
  end

  def photo_references
    PhotoReference.parse_json_array(value)
  end
end
