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
      click_link 'Ask a question'
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

    scenario 'asks a question with attached files' do
      fill_in 'Question title', with: 'Test question'
      fill_in 'Description', with: 'Some stub text'

      attach_file 'Files', %W(#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb)
      click_on I18n.translate('helpers.submit.question.create')
      click_on 'Test question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'adds reward when creating a question' do
      fill_in 'Question title', with: 'Test question with reward'
      fill_in 'Description', with: 'Some stub text'

      fill_in I18n.translate('helpers.label.reward.name'), with: 'Reward'
      attach_file I18n.translate('helpers.label.reward.image'), "#{Rails.root}/spec/static/medal_another.png"

      click_on I18n.translate('helpers.submit.question.create')
      expect(page).to have_content I18n.translate('questions.create.flash_messages.question.created')
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    expect(page).not_to have_content 'Ask a question'
  end

  context "multiple sessions", js: true do
    scenario "question appears on another users's page" do
      Capybara.using_session('user') do
        sign_in user
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        visit new_question_path

        fill_in 'Question title', with: 'Test question'
        fill_in 'Description', with: 'Some stub text'

        click_on I18n.translate('helpers.submit.question.create')
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
        expect(page).not_to have_link 'Delete'
        expect(page).not_to have_link 'Edit'
      end
    end
  end
end