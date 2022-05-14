# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    include CookieGenerator

    # rubocop:disable Metrics/AbcSize
    def create
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?

      generate_cookie
      if resource.fingerprint != params[:user][:fingerprint]
        resource.fingerprint = params[:user][:fingerprint]
        resource.save
      end

      respond_with resource, location: after_sign_in_path_for(resource)
    end
    # rubocop:enable Metrics/AbcSize
  end
end
