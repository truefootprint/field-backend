class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :authenticate#, unless: :reports_controller?
  before_action :save_metadata#, unless: :reports_controller?
  around_action :set_viewpoint#, unless: :reports_controller?
  around_action :set_locale

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from JSON::ParserError, with: :bad_request

  def reports_controller?
    controller_name == "reports"
  end

  def authenticate
    api_token || request_http_basic_authentication
  end

  def api_token
    @api_token ||= authenticate_with_http_basic do |_, t| 
      ApiToken.find_by(token: t) 
    end
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

  def set_locale
    previous = I18n.locale
    I18n.locale = locale
    yield
  ensure
    I18n.locale = previous
  end

  def admins_only
    current_user.roles.detect(&:admin?) || request_http_basic_authentication
  end

  def report_viewer
    current_user.id == 541
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

  def bad_request
    head :bad_request
  end

  def locale
    request.get_header("HTTP_ACCEPT_LANGUAGE") || request.env["Accept-Language"]
  end

  def time_zone
    request.get_header("HTTP_TIME_ZONE") || request.env["Time-Zone"]
  end

  def save_metadata
    api_token.just_used!(combined_params.select { |_, v| v.present? })
  end

  def combined_params
    field_app_params.merge(locale: locale, time_zone: time_zone)
  end

  def field_app_params
    JSON.parse(field_app_header, symbolize_names: true).slice(*METADATA)
  end

  def field_app_header
    request.get_header("HTTP_FIELD_APP") || request.env["Field-App"] || "{}"
  end

  METADATA = %i[device_id device_name device_year_class app_version app_version_code]
end
