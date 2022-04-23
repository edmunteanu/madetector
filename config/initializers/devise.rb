# frozen_string_literal: true

# https://betterprogramming.pub/devise-auth-setup-in-rails-7-44240aaed4be
# Turbo doesn't work with devise by default.
class TurboFailureApp < Devise::FailureApp
  def respond
    if request_format == :turbo_stream
      redirect
    else
      super
    end
  end

  def skip_format?
    %w[html turbo_stream */*].include? request_format.to_s
  end
end

Devise.setup do |config|
  config.parent_controller = 'TurboDeviseController'

  config.secret_key = ENV['DEVISE_SECRET_KEY']
  config.mailer_sender = ENV['MAIL_SENDER']
  config.pepper = ENV['DEVISE_PEPPER']

  config.navigational_formats = ['*/*', :html, :turbo_stream]

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.paranoid = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = URI::MailTo::EMAIL_REGEXP
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete

  config.warden do |manager|
    manager.failure_app = TurboFailureApp
  end
end
