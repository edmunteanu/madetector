# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :request do
  subject { response }

  context 'when not signed in' do
    describe 'GET #index' do
      before { get root_path }

      it { is_expected.to be_successful }
    end
  end

  context 'when signed in' do
    describe 'GET #index' do
      let(:user) { create(:user, :confirmed) }

      before do
        sign_in user
        get root_path
      end

      it { is_expected.to redirect_to users_path }
    end
  end
end
