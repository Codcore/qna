require 'rails_helper'

feature 'Author can delete links for answer', %q{
  In order to change answer
  As an author
  I'd like to delete links for answer
} do

  given(:author)   { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer)   { create(:answer, question: question, author: author) }
  given!(:link)     { create(:link, :for_answer, linkable: answer, name: 'Test link with url') }

  scenario 'Author can delete links for answer while editing it', js: true do
    sign_in author
    visit question_path(question)

    click_on I18n.translate('answers.answer.edit_button')

    within "#edit-answer-#{answer.id}" do
      expect(page).to have_content  I18n.translate('questions.link_fields.remove_link')
      click_on I18n.translate('questions.link_fields.remove_link')
      click_on I18n.translate('helpers.submit.answer.update')
    end

    expect(page).not_to have_content link.name
  end
end
