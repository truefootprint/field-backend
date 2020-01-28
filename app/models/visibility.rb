class Visibility < ApplicationRecord
  SUBJECT_TYPES = %w[
    Activity
    Involvement
    Project
    ProjectActivity
    ProjectQuestion
    ProjectType
    Question
    Topic
  ].freeze

  VISIBLE_TO_TYPES = %w[User Role UserRole].freeze

  belongs_to :subject, polymorphic: true
  belongs_to :visible_to, polymorphic: true

  validates :subject_id, uniqueness: {
    scope: %i[subject_type visible_to_type visible_to_id]
  }

  validates :subject_type, inclusion: { in: SUBJECT_TYPES }
  validates :visible_to_type, inclusion: { in: VISIBLE_TO_TYPES }
  validate :projects_visible_to_user_roles

  def self.subject_ids(subject_type)
    where(subject_type: subject_type.to_s).select(:subject_id)
  end

  def self.union(users: nil, roles: nil, user_roles: nil)
    scope = none
    scope = scope.or(where(visible_to: users)) if users
    scope = scope.or(where(visible_to: roles)) if roles
    scope = scope.or(where(visible_to: user_roles)) if user_roles
    scope
  end

  private

  def projects_visible_to_user_roles
    return unless subject_type == "Project"
    return if visible_to_type == "UserRole"

    err = "Projects should be made visible to UserRoles, not #{visible_to_type}s"
    errors.add(:base, err)
  end
end
