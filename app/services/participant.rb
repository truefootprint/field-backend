class Participant
  def self.find(*args)
    new(*args).participant
  end

  attr_accessor :project_activity, :role

  def initialize(project_activity, role)
    self.project_activity = project_activity
    self.role = role
  end

  def participant
    raise_if_no_users
    raise_if_ambiguous

    users.first
  end

  private

  def raise_if_no_users
    return if users.count > 0
    error = "Could not find a #{role.name} participating in this project activity"
    raise ActiveRecord::RecordNotFound, error
  end

  def raise_if_ambiguous
    return if users.count == 1
    error = "More than one #{role.name} is participating in this project activity"
    raise AmbiguousParticipantError, error
  end

  def users
    @users ||= User.includes(:user_roles).where(user_roles: { id: visibilities.pluck(:visible_to_id) })
  end

  def visibilities
    Visibility.where(subject: project_activity, visible_to: user_roles)
  end

  def user_roles
    UserRole.where(role: role)
  end

  class ::AmbiguousParticipantError < StandardError; end
end
