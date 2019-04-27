require 'rails_helper'

feature 'User can became registered user', %q{
  In order to be able ask questions and give answers to them
  As a guest
  I'd like to became an registered user
} do

  scenario 'User registers' do
    visit new_user_registration_path

    fill_in 'Email', with: 'user@domain.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(page).to have_content('Questions')
    expect(page).to_not have_content('Register')
  end
end