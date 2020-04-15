class Visibility < ApplicationRecord
  SUBJECT_TYPES = %w[
    Involvement
    Project
    ProjectActivity
    ProjectQuestion
  ].freeze

  VISIBLE_TO_TYPES = %w[User ProjectRole].freeze

  belongs_to :subject, polymorphic: true
  belongs_to :visible_to, polymorphic: true

  validates :subject_id, uniqueness: {
    scope: %i[subject_type visible_to_type visible_to_id]
  }

  validates :subject_type, inclusion: { in: SUBJECT_TYPES }
  validates :visible_to_type, inclusion: { in: VISIBLE_TO_TYPES }

  def self.subject_ids(subject_type)
    where(subject_type: subject_type.to_s).select(:subject_id)
  end

  def self.union(users: nil, project_roles: nil)
    scope = none
    scope = scope.or(where(visible_to: users)) if users
    scope = scope.or(where(visible_to: project_roles)) if project_roles
    scope
  end
end
