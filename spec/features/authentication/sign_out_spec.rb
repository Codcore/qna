require 'rails_helper'

feature 'Logging out authenticated user', %q{
  In order to log out
  As a authenticated user
  I'd like to destroy current session
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user logging out' do
    sign_in(user)
    click_on 'Logout'

    expect(page).to have_content('Signed out successfully.')
  end
end
