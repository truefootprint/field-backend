# This class allows users to register for specific activities on a project. For
# example, if a workshop takes place, they might register their own attendance.
# We'd then present questions about the workshop and follow up activities.

class ProjectActivityRegistration
  def self.process(*args)
    new(*args).process
  end

  attr_accessor :project_activity, :user, :role

  def initialize(project_activity, user, role)
    self.project_activity = project_activity
    self.user = user
    self.role = role
  end

  def process
    raise_if_user_is_not_registered_on_project_with_role

    create_registration(project_activity)
    make_visible(project_activity)

    follow_up_activities.each do |follow_up|
      project_activity = create_records_from_template(follow_up)
      create_registration(project_activity)
      make_visible(project_activity)
    end
  end

  private

  def create_registration(project_activity)
    Registration.create!(user: user, project_role: project_role, project_activity: project_activity)
  end

  def make_visible(project_activity)
    Visibility.create!(subject: project_activity, visible_to: user)
  end

  def project_role
    project_activity.project.project_roles.find_by!(role: role)
  end

  def follow_up_activities
    project_activity.activity.follow_up_activities
  end

  def create_records_from_template(activity)
    Template.for(activity).create_records(project_activity.project)
  end

  def raise_if_user_is_not_registered_on_project_with_role
    return if Registration.find_by(user: user, project_role: project_role)

    message = "Cannot register user #{user.id} for project activity #{project_activity.id}"
    message += " because they are not a #{role.name} on project #{project_activity.project.id}"

    raise RegistrationError, message
  end

  class ::RegistrationError < StandardError; end
end
