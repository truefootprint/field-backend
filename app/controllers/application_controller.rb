class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  around_action :set_viewpoint

  def current_user
    @current_user ||= User.find_by!(name: params.fetch(:user_name))
  end

  def set_viewpoint
    role = Role.find_by!(name: params.fetch(:role_name))

    Viewpoint.current = Viewpoint.new(user: current_user, role: role)
    yield
  ensure
    Viewpoint.current = nil
  end

  def presentation
    return {} unless params.key?(:presentation)
    @presentation ||= JSON.parse(params.fetch(:presentation), symbolize_names: true)
  end

  def record_not_found
    render status: :not_found
  end

  def record_invalid(error)
    render json: ErrorPresenter.present(error.record), status: :unprocessable_entity
  end
end
