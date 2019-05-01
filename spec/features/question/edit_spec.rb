require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct question
  As an authenticated user
  I'd like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link I18n.translate('questions.show.edit_button')
    end
  end

  describe 'Authenticated user' do
    scenario 'edits his answer' do
      sign_in user

      visit questions_path
      click_on question.title

      within('.question') do
        click_on I18n.translate('questions.show.edit_button')
      end

      fill_in I18n.translate('helpers.label.question.title'), with: 'New title'
      fill_in I18n.translate('helpers.label.question.body'), with: 'New description'
      click_on I18n.translate('helpers.submit.question.update')

      expect(page).to_not have_content(question.body)
      expect(page).to have_content('New title')
      expect(page).to have_content('New description')
    end

    scenario 'edits his question with errors' do
      sign_in user
      visit question_path(question)

      click_on I18n.translate('questions.show.edit_button')

      fill_in  I18n.translate('helpers.label.question.body'), with: nil
      click_on I18n.translate('helpers.submit.question.update')

      expect(page).to have_content I18n.translate('shared.flash.validation_error.header')
    end
  end

  describe 'Non-author' do
    scenario "cannot edit other user's question" do
      sign_in another_user

      visit question_path(question)
      within('.question') do
        expect(page).not_to have_link I18n.translate('questions.show.edit_button')
      end
    end
  end
end
