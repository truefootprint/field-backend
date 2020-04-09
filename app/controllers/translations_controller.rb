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
end
