require_relative "boot"

#require "rails/all"

require "active_storage/engine"
#require "action_mailbox/engine"
#require "action_text/engine"
require "rails"

%w(
  active_record/railtie
  
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  
  
  rails/test_unit/railtie
).each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Spacewalk
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
    config.cache_store = :memory_store
    config.assets.paths << Rails.root.join("app", "assets", "fonts") 
    config.assets.enabled = true

    config.i18n.default_locale = :'it'
  end
end
