# frozen_string_literal: true

# https://betterprogramming.pub/devise-auth-setup-in-rails-7-44240aaed4be
# Turbo doesn't work with devise by default.

# :nocov:
class TurboDeviseController < ApplicationController
  class Responder < ActionController::Responder
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
    rescue ActionView::MissingTemplate => e
      raise e if get?

      if has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
        redirect_to navigation_location
      end
    end
  end

  self.responder = Responder
  respond_to :html, :turbo_stream
end
# :nocov:
