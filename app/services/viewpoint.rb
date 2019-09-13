class Viewpoint
  thread_mattr_accessor :current

  attr_accessor :user, :role, :user_role

  def initialize(user: nil, role: nil, user_role: nil)
    self.user = user
    self.role = role
    self.user_role = user_role
  end

  def scope(klass)
    klass.where(id: visibilities.where(subject_type: klass.name).pluck(:subject_id))
  end

  private

  def visibilities
    @visibilities ||= Visibility.union(user: user, role: role, user_roles: user_roles)
  end

  def user_roles
    [user_role] if user_role
  end
end
