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
  end

  scenario 'Unauthorized user cannot add an answer' do
    visit question_path(question)

    expect(page).to_not have_field 'Answer text'
    expect(page).to_not have_button 'Create a new answer'
  end
end
