class ApplicationController < ActionController::API
  around_action :set_viewpoint

  def current_user
    @current_user ||= User.find_by!(name: params.fetch(:name))
  end

  def set_viewpoint
    role = Role.find_by!(name: params.fetch(:role))

    Viewpoint.current = Viewpoint.new(user: current_user, role: role)
    yield
  ensure
    Viewpoint.current = nil
  end
end
