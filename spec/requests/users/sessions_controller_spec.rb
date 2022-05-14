# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionsController, type: :request do
  describe 'POST #create' do
    subject(:http_request) do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: user.password,
          fingerprint: fingerprint
        }
      }
    end

    let(:user) { create(:user, :confirmed) }
    let(:fingerprint) { 'asdf' }

    it 'creates a cookie on login' do
      http_request

      jar = ActionDispatch::Cookies::CookieJar.build(request, response.cookies)
      expect(jar[:existing_user]).not_to be_blank
    end

    context 'when the saved fingerprint is the same as the one on login' do
      let(:user) { create(:user, :confirmed, fingerprint: fingerprint) }

      it 'does not update the fingerprint' do
        expect { http_request }.not_to(change { user.reload.fingerprint })
      end
    end

    context 'when the saved fingerprint is different from the one on login' do
      it 'updates the fingerprint' do
        expect { http_request }.to(change { user.reload.fingerprint }.to(fingerprint))
      end
    end
  end
end
