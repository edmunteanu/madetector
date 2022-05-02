# frozen_string_literal: true

module CookieGenerator
  extend ActiveSupport::Concern

  def generate_cookie
    cookies[:existing_user] = {
      value: true,
      expires: 1.month,
      domain: ENV['APP_HOST']
    }
  end
end
