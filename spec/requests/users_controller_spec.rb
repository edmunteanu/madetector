# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  subject { response }

  context 'when not signed in' do
    let(:http_request) { get users_path }

    it 'redirects to the login page' do
      expect(http_request).to redirect_to new_user_session_url
    end
  end

  context 'when signed in' do
    let(:user) { create(:user, :confirmed) }

    before do
      sign_in user
      get users_path
    end

    it 'shows all users' do
      expect(response.body).to include(user.email)
    end
  end
end
