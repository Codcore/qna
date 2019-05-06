require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct question
  As an authenticated user
  I'd like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    before { sign_in user }

    scenario 'edits his answer' do
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
      visit question_path(question)

      click_on I18n.translate('questions.show.edit_button')

      fill_in  I18n.translate('helpers.label.question.body'), with: nil
      click_on I18n.translate('helpers.submit.question.update')

      expect(page).to have_content I18n.translate('shared.flash.validation_error.header')
    end

    scenario 'edit his question and adds files' do
      visit question_path(question)
      click_on I18n.translate('questions.show.edit_button')

      attach_file 'Files', %W(#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb)
      click_on I18n.translate('helpers.submit.question.update')

      within '.question' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario "Non-author cannot edit other user's question" do
    sign_in another_user

    visit question_path(question)
    within('.question') do
      expect(page).not_to have_link I18n.translate('questions.show.edit_button')
    end
  end

  scenario 'Unauthenticated user cannot edit questions' do
    visit(question_path(question))

    expect(page).to_not have_link I18n.translate('questions.show.edit_button')
  end
end
