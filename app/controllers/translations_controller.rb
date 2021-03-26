# Render a list of 'pre-login' translations that are bundled into FieldApp at
# build time so that we can translate text that appears before the user has
# logged in and fetched user_interface_text from the /my_data endpoint.

class TranslationsController < ActionController::API # Don't inherit, no token required.
  def index
    scope = UserInterfaceText.where(pre_login: true)

    body = scope.locales.each.with_object({}) do |locale, hash|
      I18n.with_locale(locale) do
        hash[locale] = UserInterfaceTextPresenter.present(scope)
      end
    end

    render json: body
  end

  def supported_locales
    a = JSON.load File.open("#{Rails.root}/config/data/locales.json")    
    render json: a.to_json
  end

  def select_locale
    locale = request.get_header("HTTP_ACCEPT_LANGUAGE") || request.env["Accept-Language"]
    previous = I18n.locale
    I18n.locale = locale
    render json: locale.to_json
  end
end
