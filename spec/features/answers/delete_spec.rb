require 'rails_helper'

feature 'Author can delete his answer', %q{
  In order to cancel created answer
  As an author
  I'd like to be able to delete my answers
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Author can delete his answer', js: true do
    sign_in user

    visit(question_path(question))
    expect(page).to have_content(answer.body)

    within '.answers' do
      accept_confirm do
        click_on I18n.translate('questions.show.delete_button')
      end
    end

    expect(page).not_to have_content answer.body
  end

  scenario 'Non-author cannot delete answer created by another user' do
    sign_in another_user

    visit(question_path(question))
    expect(page).to have_content(answer.body)
    within '.answers' do
      expect(page).to_not have_link'Delete'
    end
  end

  scenario 'Not logged in user cannot delete answers' do
    visit(question_path(answer.question))

    expect(page).to_not have_link('Delete')
  end
end
