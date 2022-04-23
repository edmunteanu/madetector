# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlashHelper, type: :helper do
  describe '#alert_class_for' do
    it 'returns the correct value for bootstrap' do
      expect(helper.alert_class_for('notice')).to eq('alert-success')
      expect(helper.alert_class_for('alert')).to eq('alert-info')
    end

    it 'also works with symbol values' do
      expect(helper.alert_class_for(:alert)).to eq('alert-info')
    end

    it 'returns the type as string if the type is unknown' do
      expect(helper.alert_class_for(:bla_bla)).to eq('bla_bla')
    end
  end
end
