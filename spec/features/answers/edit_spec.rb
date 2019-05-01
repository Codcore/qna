require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct answer
  As an authenticated user
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
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

    scenario 'edits his answer with errors' do
      sign_in user
      visit question_path(question)

      click_on I18n.translate('answers.answer.edit_button')
      within(".answers #edit-answer-#{answer.id}") do
        fill_in  I18n.translate('helpers.label.answer.body'), with: nil
      end

      click_on I18n.translate('helpers.submit.answer.update')
      expect(page).to have_content I18n.translate('shared.flash.validation_error.header')
    end
  end

  scenario "cannot edit other user's answer" do
    sign_in another_user

    visit question_path(question)
    within('.answers') do
      expect(page).not_to have_link I18n.translate('answers.answer.edit_button')
    end
  end

  scenario 'Not logged in user cannot edit answers' do
    visit(question_path(question))

    within('.answers') do
      expect(page).to_not have_link I18n.translate('answers.answer.edit_button')
    end
  end
end
