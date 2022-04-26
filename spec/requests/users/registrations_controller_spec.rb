# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :request do
  describe 'POST #create' do
    subject(:http_request) { post user_registration_path, params: params }

    let(:params) { { user: basic_params } }

    context 'with invalid parameters' do
      let(:basic_params) { {} }

      it 'does not create a user' do
        expect { http_request }.not_to change(User, :count)
      end
    end

    context 'with valid parameters' do
      let(:basic_params) { attributes_for(:user) }

      context 'when a user with a similar IP to the request IP exists' do
        let(:user) { create(:user, :confirmed, current_sign_in_ip: ip_address) }
        let(:ip_address) { '123.123.123.123' }

        before do
          user
          # rubocop:disable RSpec/AnyInstance
          allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(ip_address)
          # rubocop:enable RSpec/AnyInstance
        end

        it 'does not create a new user' do
          expect { http_request }.not_to change(User, :count)
        end

        it 'displays the sign up page again' do
          expect(http_request).to redirect_to(new_user_registration_path)
        end

        it 'shows an alert with the correct message' do
          http_request
          expect(flash[:notice]).to eq I18n.t('devise.registrations.new.notice')
        end
      end

      context 'when no user with a similar IP to the request IP exists' do
        it 'creates a new user' do
          expect { http_request }.to change(User, :count)
        end

        it 'redirects to the home page' do
          expect(http_request).to redirect_to(root_path)
        end
      end
    end
  end
end
