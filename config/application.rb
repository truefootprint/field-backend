require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "active_storage/engine"

Bundler.require(*Rails.groups)

module ReporterBackend
  class Application < Rails::Application
    config.load_defaults 6.0
    config.api_only = true
    config.autoload_paths += Dir["#{config.root}/app/models/**"]
  end
end
