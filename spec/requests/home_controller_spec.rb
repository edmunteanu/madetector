# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :request do
  subject { response }

  describe 'GET #index' do
    before { get root_path }

    it { is_expected.to be_successful }
  end
end
