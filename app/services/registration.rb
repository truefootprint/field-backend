class Registration
  def self.process(*args)
    new(*args).process
  end

  attr_accessor :viewpoint, :subject

  def initialize(viewpoint:, subject:)
    self.viewpoint = viewpoint
    self.subject = subject
  end

  def process
    raise_if_no_user
    make_subject_visible
    run_registration_actions
  end

  private

  def raise_if_no_user
    return if user
    raise RegistrationError, "registration must be on behalf of a user or user/role"
  end

  def make_subject_visible
    Visibility.create!(subject: subject, visible_to: user_role || user)
  end

  def run_registration_actions
    registration_actions_class&.run(subject, viewpoint)
  end

  def registration_actions_class
    "Registration::#{subject.class.name}Actions".safe_constantize
  end

  def user_role
    UserRole.find_or_create_by!(user: user, role: role) if role
  end

  def user
    viewpoint.user
  end

  def role
    viewpoint.role
  end

  class ::RegistrationError < StandardError; end
end
