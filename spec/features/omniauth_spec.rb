require 'rails_helper'

feature 'User can log in throughout OAuth', %q{
  In order to quickly log in
  As an user
  I'd like to be able to login throughout social networks
} do

  it 'should be able to login using Github', :js do
    visit new_user_session_path
    expect(page).to have_content 'Sign in with GitHub'
    mock_github_auth_hash
    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'
    find_link('Logout', visible: false)

    within('.navbar') do
      expect(page).to have_link 'Logout', visible: false
    end
  end

  it 'should be able to login using Twitter' do
    # visit new_user_session_path
    # expect(page).to have_content 'Sign in with Twitter'
    # mock_auth_hash[:twitter]
    # click_on 'Sign in with Twitter'
    # expect(page).to have_content 'Enter your e-mail'
  end

  it 'should be able to login using Google' do
    visit new_user_session_path
    expect(page).to have_content 'Sign in with GoogleOauth2'
    mock_google_auth_hash
    click_on 'Sign in with GoogleOauth2'
    expect(page).to have_content 'Successfully authenticated from Google account.'
    find_link('Logout', visible: false)

    within('.navbar') do
      expect(page).to have_link 'Logout', visible: false
    end
  end
end