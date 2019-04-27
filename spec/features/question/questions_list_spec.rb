require 'rails_helper'

feature 'User can browse questions list', %q{
  In order to find a question
  As an user
  I'd like to see a list of all questions
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:another_user) { create(:user) }

  scenario 'Authenticated user visits questions page' do
    sign_in(user)
    visit questions_path

    expect(page).to have_content'Questions'
    expect(page).to have_content'Actions'
  end

  scenario 'Unauthenticated user visits questions page' do
    visit questions_path

    expect(page).to have_content'Questions'
  end

  scenario 'Author can edit and delete his questions' do
    sign_in(user)

    visit questions_path
    save_and_open_page
    expect(page).to have_button'Edit'
    expect(page).to have_button'Delete'
  end

  scenario 'User cannot edit and delete questions of other users' do
    sign_in(another_user)

    visit questions_path
    expect(page).to_not have_button'Edit'
    expect(page).to_not have_button'Delete'
  end
end