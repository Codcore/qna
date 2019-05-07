require 'rails_helper'

feature 'Author can delete attached files for his answers', %q{
  In order to remove attached files to answer
  As an author
  I'd like to delete them through delete button
} do

  given(:author)   { create(:user) }
  given(:another_user)   { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer_1) { create(:answer, :with_files, question: question, author: author) }
  given!(:answer_2) { create(:answer, question: question) }

  scenario 'Author can delete attached files to his answer', js: true do
    sign_in author
    visit question_path(question)

    within ".answers #answer-#{answer_1.id}" do
      file_id = answer_1.files.last.id

      expect(page).to have_link(class: 'delete-file-link', count: 1)
      click_link(class: 'delete-file-link')

      expect(page).not_to have_css("#attachment-#{file_id}")
      expect(page).not_to have_content 'rails_helper.rb'
    end
  end

  scenario 'Non author cannot delete attachments' do
    visit question_path(question)

    within ".answers #answer-#{answer_1.id}" do
      expect(page).not_to have_link(class: 'delete-file-link')
    end
  end

  scenario 'Unauthenticated user cannot delete attachments' do
    sign_in another_user
    visit question_path(question)

    within ".answers #answer-#{answer_1.id}" do
      expect(page).not_to have_link(class: 'delete-file-link')
    end
  end
end