class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :authenticate
  around_action :set_viewpoint

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  def authenticate
    api_token || request_http_basic_authentication
  end

  def api_token
    @api_token ||= authenticate_with_http_basic { |_, t| ApiToken.find_by(token: t) }
  end

  def current_user
    @current_user ||= api_token.user
  end

  def set_viewpoint
    Viewpoint.current = Viewpoint.for_user(current_user)
    yield
  ensure
    Viewpoint.current = nil
  end

  def admins_only
    current_user.roles.detect(&:admin?) || request_http_basic_authentication
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
