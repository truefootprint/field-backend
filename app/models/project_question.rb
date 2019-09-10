class ProjectQuestion < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :question
end
