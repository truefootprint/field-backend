require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "active_storage/engine"

Bundler.require(*Rails.groups)

module FieldBackend
  class Application < Rails::Application
    config.load_defaults 6.0
    config.api_only = true
    config.autoload_paths += Dir["#{config.root}/app/models/**"]

    # Fall back to English for UI text / validation errors.
    config.i18n.fallbacks = %i[en-GB en]
    config.i18n.enforce_available_locales = false
  end
end
