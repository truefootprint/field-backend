class ExpectedValue < ApplicationRecord
  belongs_to :project_question
  belongs_to :unit, optional: true
  has_many :source_materials, class_name: :SourceMaterial, as: :subject, inverse_of: :subject

  validates :project_question, uniqueness: true
  validates :value, presence: true
end
