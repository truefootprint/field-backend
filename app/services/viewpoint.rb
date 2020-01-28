class Viewpoint
  thread_mattr_accessor :current

  def self.for_user(user)
    new(users: user, roles: user.roles, user_roles: user.user_roles)
  end

  attr_accessor :users, :roles, :user_roles

  def initialize(users: nil, roles: nil, user_roles: nil)
    self.users = [users].flatten
    self.roles = [roles].flatten
    self.user_roles = user_roles
  end

  def scope(klass)
    klass.where(id: visibilities.subject_ids(klass.name))
  end

  def user
    raise AmbiguousError, "there is more than one user" if users.size > 1
    users.first
  end

  def role
    raise AmbiguousError, "there is more than one role" if roles.size > 1
    roles.first
  end

  private

  def visibilities
    @visibilities ||= Visibility.union(users: users, roles: roles, user_roles: user_roles)
  end

  class AmbiguousError < StandardError; end
end
