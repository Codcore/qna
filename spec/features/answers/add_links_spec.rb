require 'rails_helper'

feature 'User can add links to the answer', %q{
  In order to provide additional info to my answer
  As an answer author
  I'd like to be able to add links
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer)   { create(:answer, question: question, author: user) }
  given(:gist_url) { 'https://gist.github.com/Codcore/022e6257f0fe09cd0f8f47cdafb48f37' }


  context 'New answer' do
    background do
      sign_in user
      visit question_path(question)
      click_on 'add link'
      fill_in I18n.translate('helpers.label.answer.body'), with: 'Test answer'
      fill_in I18n.translate('helpers.label.link.name'), with: 'My link'
    end

    scenario 'User adds link when asks answer with GitHub Gist url', js: true do
      fill_in I18n.translate('helpers.label.link.url'), with: gist_url

      click_on I18n.translate('helpers.submit.answer.create')

      expect(page).to have_selector('div.gist')
    end

    scenario 'User adds link and links form resets', js: true do
      fill_in I18n.translate('helpers.label.link.url'), with: 'http://google.com'

      click_on I18n.translate('helpers.submit.answer.create')

      expect(page).not_to have_content(I18n.translate('helpers.label.link.name'))
      expect(page).not_to have_content(I18n.translate('helpers.label.link.url'))
    end

    scenario 'User adds link when asks answer with invalid url', js: true do
      fill_in I18n.translate('helpers.label.link.url'), with: 'some_url'

      click_on I18n.translate('helpers.submit.answer.create')

      expect(page).to have_content 'Links url is invalid'
    end
  end

  context 'Existing answer' do

    scenario 'Author can add links for answer while editing it', js: true do
      sign_in user
      visit question_path(question)

      click_on I18n.translate('answers.answer.edit_button')

      within "#edit-answer-#{answer.id}" do
        expect(page).to have_content  I18n.translate('answers.form.add_link')
        click_on I18n.translate('answers.form.add_link')
        fill_in I18n.translate('helpers.label.link.name'), with: 'Test Link'
        fill_in I18n.translate( 'helpers.label.link.url'), with: 'http://google.com'
        click_on I18n.translate('helpers.submit.answer.update')
      end

      expect(page).to have_content('Test Link')
    end
  end
end
