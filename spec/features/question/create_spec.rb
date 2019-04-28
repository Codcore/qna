require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do

    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask a question'
    end

    scenario 'asks a question' do
      fill_in 'Question title', with: 'Test question'
      fill_in 'Description', with: 'Some stub text'
      click_on 'Create a new question'

      expect(page).to have_content 'Your question is successfully created.'
      expect(page).to have_content 'Test question'
    end

    scenario 'asks a question with errors' do
      fill_in 'Question title', with: nil
      fill_in 'Description', with: nil
      click_on 'Create a new question'

      expect(page).to have_content 'Errors found'
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"

      expect(page).to have_field 'Question title'
      expect(page).to have_field 'Description'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask a question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end