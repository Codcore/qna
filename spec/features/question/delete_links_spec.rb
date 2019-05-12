require 'rails_helper'

feature 'Author can delete links for question', %q{
  In order to change question
  As an author
  I'd like to delete links for question
} do

  given(:author)   { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:link)     { create(:link, :for_question, linkable: question, name: 'Test link with url') }

  scenario 'Author can delete links for answer while editing it', js: true do
    sign_in author
    visit question_path(question)


    click_on I18n.translate('questions.show.edit_button')
    expect(page).to have_content  I18n.translate('questions.link_fields.remove_link')
    click_on I18n.translate('questions.link_fields.remove_link')
    click_on I18n.translate('helpers.submit.question.update')

    expect(page).not_to have_content link.name
  end
end
