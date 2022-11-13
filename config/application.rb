require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_job.queue_adapter = :sidekiq
    config.autoload_paths += [config.root.join('app')]

    config.generators do |g|
      g.test_framework :rspec 
      g.controller_specs true
      g.view_specs false
      g.helper_specs false
      g.routing_specs false
      g.request_specs false
    end
  end
end
