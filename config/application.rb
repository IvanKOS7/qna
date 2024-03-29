require_relative "boot"
require "action_cable"
require "rails/all"
require 'sprockets/railtie'
require "active_storage/engine"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    #config.load_defaults 6.0
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.autoload_paths += [config.root.join('app')]

    config.middleware.insert_after Rack::Runtime, Rack::MethodOverride
    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false

   end

   config.active_job.queue_adapter = :sidekiq
   config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
   config.i18n.default_locale = :en
  end
end
