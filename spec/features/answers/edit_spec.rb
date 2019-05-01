require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct answer
  As an authenticated user
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his answer' do
      sign_in user

      visit questions_path
      click_on question.title

      click_on 'Edit'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        fill_in 'Answer text', with: 'Edited answer'
        click_on 'Update answer'

        expect(page).to_not have_content(answer.body)
        expect(page).to have_content('Edited answer')
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors'
    scenario "tries to edit other user's answer"
  end
end
