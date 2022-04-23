# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Madetector
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.time_zone = 'Zurich'
    config.i18n.default_locale = :en
    config.i18n.available_locales = :en
    config.action_mailer.default_url_options = { host: ENV['APP_HOST'], port: ENV['APP_PORT'] }
  end
end
