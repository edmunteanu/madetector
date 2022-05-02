# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionsController, type: :request do
  describe 'POST #create' do
    subject(:http_request) do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    let(:user) { create(:user, :confirmed) }

    it 'creates a cookie on login' do
      http_request

      jar = ActionDispatch::Cookies::CookieJar.build(request, response.cookies)
      expect(jar[:existing_user]).not_to be_blank
    end
  end
end
