require 'rails_helper'

feature 'Author can delete his answer', %q{
  In order to cancel created answer
  As an author
  I'd like to be able to delete my answers
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Author can delete his answer' do
    sign_in user

    visit(question_path(question))
    expect(page).to have_content(answer.body)
    page.all(:link, 'Delete')[1].click

    expect(page).not_to have_content(answer.body)
  end

  scenario 'Non-author cannot delete answer created by another user' do
    sign_in another_user

    visit(question_path(question))
    expect(page).to have_link('Delete', count: 1)
  end
end
