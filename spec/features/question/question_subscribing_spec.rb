require 'rails_helper'

feature 'User can subscribe for question updates', %q{
  In order to correct question
  As an authenticated user
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:another_user) { create(:user) }

  describe 'Authenticated user', js: true do
    before { sign_in user }

    scenario 'can subscribe for question updates' do
      visit question_path(question)

      within '.question' do
        expect(page).to have_content('Subscribe')
      end

      click_on('Subscribe')
      expect(page).to have_content('Unsubscribe')
      expect(page).not_to have_content('Subscribe')
    end
  end

  describe 'Unauthenticated user' do

    scenario 'can not subscribe for question updates' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_content('Subscribe')
      end
    end
  end
end
