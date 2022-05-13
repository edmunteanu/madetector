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

      context 'when no cookie, no similar IP and no similar fingerprint exists' do
        it 'creates a new user' do
          expect { http_request }.to change(User, :count)
        end

        it 'generates a cookie' do
          http_request
          jar = ActionDispatch::Cookies::CookieJar.build(request, response.cookies)
          expect(jar[:existing_user]).not_to be_blank
        end

        it 'redirects to the home page' do
          expect(http_request).to redirect_to(root_path)
        end
      end

      context 'when a user with only a similar fingerprint exists' do
        let(:user) { create(:user, :confirmed, fingerprint: fingerprint) }
        let(:params) { { user: basic_params.merge(fingerprint: fingerprint) } }
        let(:fingerprint) { 'abcd' }

        before { user }

        it 'creates a new user' do
          expect { http_request }.to change(User, :count)
        end

        it 'redirects to the home page' do
          expect(http_request).to redirect_to(root_path)
        end
      end

      context 'when a user with only a similar IP exists' do
        let(:user) { create(:user, :confirmed, current_sign_in_ip: ip_address) }
        let(:ip_address) { '123.123.123.123' }

        before do
          user
          # rubocop:disable RSpec/AnyInstance
          allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(ip_address)
          # rubocop:enable RSpec/AnyInstance
        end

        it 'creates a new user' do
          expect { http_request }.to change(User, :count)
        end

        it 'redirects to the home page' do
          expect(http_request).to redirect_to(root_path)
        end
      end

      context 'when a user with both a similar IP and a fingerprint exists' do
        let(:user) { create(:user, :confirmed, current_sign_in_ip: ip_address, fingerprint: fingerprint) }
        let(:params) { { user: basic_params.merge(fingerprint: fingerprint) } }
        let(:ip_address) { '123.123.123.123' }
        let(:fingerprint) { 'abcd' }

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

      context 'when the cookie is present' do
        let(:user) { create(:user, :confirmed) }

        before do
          cookies[:existing_user] = true
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
    end
  end
end
