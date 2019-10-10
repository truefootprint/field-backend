class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  if BasicAuth.enabled?
    http_basic_authenticate_with(
      name: BasicAuth.username,
      password: BasicAuth.password
    )
  end

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

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
