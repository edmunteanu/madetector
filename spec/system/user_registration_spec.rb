# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User registration', :js do
  let(:first_user) { build(:user) }
  let(:second_user) { build(:user) }

  it 'can register and confirm the first account but blocks the second one' do
    visit new_user_registration_path

    expect do
      fill_and_submit_form(first_user)
      expect(page).to have_content(I18n.t('devise.registrations.signed_up_but_unconfirmed'))
    end.to change(User, :count).by(1)

    visit_in_email(I18n.t('devise.mailer.confirmation_instructions.confirm'), first_user.email)
    expect(page).to have_content(I18n.t('devise.confirmations.confirmed'))

    visit new_user_registration_path

    expect do
      fill_and_submit_form(second_user)
      expect(page).to have_content(I18n.t('devise.registrations.new.notice'))
    end.not_to change(User, :count)
  end

  def fill_and_submit_form(user)
    fill_in(User.human_attribute_name(:email), with: user.email)
    fill_in('user_password', with: user.password)
    fill_in('user_password_confirmation', with: user.password)

    within 'form#new_user' do
      find('[type="submit"]').click
    end
  end
end
