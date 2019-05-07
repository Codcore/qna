require 'rails_helper'

feature 'Author can delete attached files for his questions', %q{
  In order to remove attached files to questions
  As an author
  I'd like to delete them through delete button
} do

  given(:author)   { create(:user) }
  given(:another_user)   { create(:user) }
  given!(:question) { create(:question, :with_files, author: author) }

  scenario 'Author can delete attached files to his question', js: true do
    sign_in author
    visit question_path(question)

    within ".question" do
      file_id = question.files.last.id

      expect(page).to have_link(class: 'delete-file-link', count: 1)
      accept_confirm do
        click_link(class: 'delete-file-link')
      end

      expect(page).not_to have_css("#attachment-#{file_id}")
      expect(page).not_to have_link(class: 'delete-file-link')
      expect(page).not_to have_content 'rails_helper.rb'
    end
  end

  scenario 'Non author cannot delete attachments' do
    visit question_path(question)

    within ".question" do
      expect(page).not_to have_link(class: 'delete-file-link')
    end
  end

  scenario 'Unauthenticated user cannot delete attachments' do
    sign_in another_user
    visit question_path(question)

    within ".question" do
      expect(page).not_to have_link(class: 'delete-file-link')
    end
  end
end