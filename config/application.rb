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
    config.autoloader = :classic
    #it's zeitwerk bug you can just upgrade your rails version to 6.1.x and everything should work fine
    #if you don't want to upgrade - switch to the classic load mode by adding in application.rb

    # Fall back to English for UI text / validation errors.
    config.i18n.fallbacks = %i[en-GB en]
    config.i18n.available_locales = [:en, :fr, :es, :pt, :sw, :mg, :tet, :am, :id, :rw, :ro, :laj]
    config.i18n.enforce_available_locales = false
  end
end
