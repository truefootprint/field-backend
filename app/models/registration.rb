class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :project_role
  belongs_to :project_activity, optional: true

  validates :user, uniqueness: { scope: %i[project_role project_activity] }
  validate :role_and_activity_belong_to_the_same_project

  private

  def role_and_activity_belong_to_the_same_project
    return if project_activity.nil?
    return if project_activity.project == project_role.project

    errors.add(:project_activity, "does not match the project of the project_role")
  end
end
