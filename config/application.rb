require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Test
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    # Responders
    config.app_generators.scaffold_controller :responders_controller
    config.responders.flash_keys = [ :success, :error ]
    config.active_record.belongs_to_required_by_default = false

    # TimeZone
    config.time_zone = 'Brasilia'
    config.active_record.default_timezone = :local
    # config.active_record.time_zone_aware_attributes = 'America/Sao_Paulo'

    # I18n
    config.i18n.default_locale = 'pt-BR'

    config.active_job.queue_adapter = :sidekiq
    # Helper
    #
    config.action_controller.include_all_helpers = false

    Time::DATE_FORMATS[:default] = "%d/%m/%Y %H:%M:%S"
    Date::DATE_FORMATS[:default] = "%d/%m/%Y"

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    Bundler.require(*Rails.groups(:assets => %w(development test production)))
    RenderAsync.configure do |config|
      config.jquery = true # This will render jQuery code, and skip Vanilla JS code
      config.turbolinks = false # Enable this option if you are using Turbolinks 5+
    end
  end
end
