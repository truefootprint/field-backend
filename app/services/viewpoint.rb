class Viewpoint
  thread_mattr_accessor :current

  def self.for_user(user)
    new(users: user, project_roles: user.project_roles)
  end

  attr_accessor :users, :project_roles

  def initialize(users: nil, project_roles: nil)
    self.users = [users].flatten
    self.project_roles = project_roles
  end

  def scope(klass)
    klass.where(id: visibilities.subject_ids(klass.name))
  end

  def user
    raise AmbiguousError, "there is more than one user" if users.size > 1
    users.first
  end

  def project_role
    raise AmbiguousError, "there is more than one project_role" if project_roles.size > 1
    project_roles.first
  end

  private

  def visibilities
    @visibilities ||= Visibility.union(users: users, project_roles: project_roles)
  end

  class AmbiguousError < StandardError; end
end
