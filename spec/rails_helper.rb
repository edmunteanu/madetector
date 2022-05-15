# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require_relative '../config/environment'
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'email_spec'
require 'email_spec/rspec'
require 'selenium/webdriver'
require 'super_diff/rspec-rails'

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  config.include JavaScriptErrorReporter, type: :system, js: true
  config.include Devise::Test::IntegrationHelpers, type: :request

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.before do |example|
    ActionMailer::Base.deliveries.clear
    I18n.locale = I18n.default_locale # rubocop:disable Rails/I18nLocaleAssignment
    Rails.logger.debug { "--- #{example.location} ---" }
  end

  config.after do |example|
    Rails.logger.debug { "--- #{example.location} FINISHED ---" }
  end

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by ENV['SELENIUM_DRIVER']&.to_sym || :selenium_chrome_headless
  end
end
