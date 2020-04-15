class Visibility < ApplicationRecord
  SUBJECT_TYPES = %w[Project ProjectActivity ProjectQuestion].freeze
  VISIBLE_TO_TYPES = %w[User ProjectRole].freeze

  belongs_to :subject, polymorphic: true
  belongs_to :visible_to, polymorphic: true

  validates :subject_id, uniqueness: {
    scope: %i[subject_type visible_to_type visible_to_id]
  }

  validates :subject_type, inclusion: { in: SUBJECT_TYPES }
  validates :visible_to_type, inclusion: { in: VISIBLE_TO_TYPES }
  validate :project_role_belongs_to_the_same_project

  def self.subject_ids(subject_type)
    where(subject_type: subject_type.to_s).select(:subject_id)
  end

  def self.union(users: nil, project_roles: nil)
    scope = none
    scope = scope.or(where(visible_to: users)) if users
    scope = scope.or(where(visible_to: project_roles)) if project_roles
    scope
  end

  private

  def project_role_belongs_to_the_same_project
    return unless visible_to.is_a?(ProjectRole)

    expected_project = subject.is_a?(Project) ? subject : subject.project
    return if visible_to.project == expected_project

    errors.add(:project_role, "does not match the project of the subject")
  end
end
