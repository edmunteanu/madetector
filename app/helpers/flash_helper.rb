# frozen_string_literal: true

module FlashHelper
  def alert_class_for(flash_type)
    {
      notice: 'alert-success',
      alert: 'alert-info'
    }.fetch(flash_type.to_sym, flash_type.to_s)
  end
end
