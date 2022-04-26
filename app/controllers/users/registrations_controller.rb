# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def create
      build_resource(sign_up_params)

      client_ip = request.remote_ip

      resource.last_sign_in_ip = client_ip
      resource.current_sign_in_ip = client_ip

      if resource.invalid?
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
        return
      end

      if user_amount_with_ip(client_ip).zero?
        resource.save
        yield resource if block_given?

        if resource.active_for_authentication?
          # Covered by tests already in the Devise Test Suite
          # :nocov:
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
          # :nocov:
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        redirect_to new_user_registration_path, notice: I18n.t('devise.registrations.new.notice')
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    private

    def user_amount_with_ip(client_ip)
      # if the client_ip is in IPv6 format, the following code will assign the whole IP instead of shortening it
      query_ip = "#{client_ip.split('.').first(3).join('.')}%"
      User.where('current_sign_in_ip LIKE ? OR last_sign_in_ip LIKE ?', query_ip, query_ip).count
    end
  end
end
