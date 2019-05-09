require 'rails_helper'

feature 'Add answer on question page', %q{
  In order to give a help with question
  As authenticated user
  I'd like to add new answer on the question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authentificated user visits question page', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'he can add an answer', js: true do
      fill_in 'Answer text', with: 'New answer is here'
      click_on 'Create a new answer'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to have_content 'New answer is here'
      end

      within '#answers-count' do
        expect(page).to have_content "#{I18n.translate("questions.show.answers_count", count: question.answers.count)}"
      end
    end

    scenario 'he cannot add an answer with validation errors' do
      click_on 'Create a new answer'

      expect(page).to have_content 'Errors found:'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'he can add an answer with attached files', js: true do
      fill_in I18n.translate('helpers.label.answer.body'), with: 'Test question'
      page.execute_script("$('input[id=answer_files]').css('opacity','1')")
      attach_file 'Files', %W(#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb)
      click_on I18n.translate('helpers.submit.answer.create')

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'

      fill_in I18n.translate('helpers.label.answer.body'), with: 'Test question'
      click_on I18n.translate('helpers.submit.answer.create')
      expect(page).to have_link 'rails_helper.rb', count: 1
      expect(page).to have_link 'spec_helper.rb', count: 1
    end
  end

  scenario 'Unauthorized user cannot add an answer' do
    visit question_path(question)

    expect(page).to_not have_field 'Answer text'
    expect(page).to_not have_button 'Create a new answer'
  end
end