require 'rails_helper'

feature 'Author can delete attached files for his answers', %q{
  In order to remove attached files to answer
  As an author
  I'd like to delete them through delete button
} do

  given(:author)   { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer_1) { create(:answer, question: question, author: author) }
  given!(:answer_2) { create(:answer, question: question) }

  scenario 'Author can delete attached files to his answer', js: true do
    sign_in author
    visit question_path(question)

    within ".answers #answer-#{answer_1.id}" do
      click_on I18n.translate('answers.answer.edit_button')
    end

    within ".answers #edit-answer-#{answer_1.id}" do
      page.execute_script("$('input[id=answer_files]').css('opacity','1')")
      attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
      click_on I18n.translate('helpers.submit.answer.update')
    end

    within ".answers #answer-#{answer_1.id}" do
      expect(page).to have_link(class: 'delete-file-link', count: 1)
      first('.delete-file-link').click

      expect(page).not_to have_link(class: 'delete-file-link')
      expect(page).not_to have_content 'rails_helper.rb'
    end
  end
end