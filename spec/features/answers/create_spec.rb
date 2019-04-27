require 'rails_helper'

feature 'Add answer on question page', %q{
  In order to give a help with question
  As authorized user
  I'd like to add new answer on the question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authorized user visit question page' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'he can see form for adding an answer' do
      expect(page).to have_field 'Answer text'
      expect(page).to have_button 'Create a new answer'
    end

    scenario 'he can add an answer' do
      fill_in 'Answer text', with: 'New answer is here'
      click_on 'Create a new answer'

      expect(page).to have_content('New answer is here')
    end
  end

  scenario 'Unauthorized user cannot add an answer' do
    visit question_path(question)

    expect(page).to_not have_field 'Answer text'
    expect(page).to_not have_button 'Create a new answer'
  end

end
