require 'rails_helper'

feature 'User can browse questions list', %q{
  In order to find a question
  As an user
  I'd like to see a list of all questions
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:another_user) { create(:user) }

  describe 'Authenticated user visits questions page' do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'he can see actions column' do
      expect(page).to have_content'Questions'
      expect(page).to have_content'Actions'
    end

    scenario 'he can see buttons for editing and deleting his questions' do
      expect(page).to have_button'Edit'
      expect(page).to have_button'Delete'
    end
  end

  scenario 'Authenticated user cannot edit and delete questions of other users' do
    sign_in(another_user)

    visit questions_path
    expect(page).to_not have_button'Edit'
    expect(page).to_not have_button'Delete'
  end

  describe 'Unauthenticated user visits question page' do

    scenario 'he can see list of questions' do
      visit questions_path

      expect(page).to have_content(question.title)
    end

    scenario 'he cannot see buttons for editing and deleting questions' do
      visit questions_path

      expect(page).to_not have_button'Edit'
      expect(page).to_not have_button'Delete'
    end
  end
end