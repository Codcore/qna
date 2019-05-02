require 'rails_helper'

feature 'Author can delete his question', %q{
  In order to cancel created question
  As an author
  I'd like to be able to delete my questions
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario 'Author can delete his question' do
    sign_in user

    visit(question_path(question))
    expect(page).to have_content(question.title)
    page.all(:link, 'Delete')[0].click

    expect(page).not_to have_content(question.title)
  end

  scenario 'Non-author cannot delete answer created by another user' do
    sign_in another_user

    visit(question_path(question))
    expect(page).not_to have_link('Delete')
  end

  scenario 'Unauthenticated user cannot delete answers' do
    visit(question_path(question))

    expect(page).to_not have_link('Delete')
  end
end