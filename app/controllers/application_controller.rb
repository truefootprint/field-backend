class ApplicationController < ActionController::API
  around_action :set_viewpoint

  def set_viewpoint
    user = User.find_by!(name: params.fetch(:name))
    role = Role.find_by!(name: params.fetch(:role))

    Viewpoint.current = Viewpoint.new(user: user, role: role)
    yield
  ensure
    Viewpoint.current = nil
  end
end
