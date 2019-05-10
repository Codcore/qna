require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:google_url) { 'https://google.com' }

  background do
    sign_in user
    visit new_question_path

    click_on 'add link'
  end

  scenario 'User adds link when asks question', js: true do

    fill_in I18n.translate('helpers.label.question.title'), with: 'Test question'
    fill_in I18n.translate('helpers.label.question.body'), with: 'Test description'

    fill_in I18n.translate('helpers.label.link.name'), with: 'My gist'
    fill_in I18n.translate('helpers.label.link.url'), with: google_url

    click_on I18n.translate('helpers.submit.question.create')
    click_on 'Test question'
    expect(page).to have_link 'My gist', href: google_url
  end

  scenario 'User adds link when asks question with invalid url', js: true do
    fill_in I18n.translate('helpers.label.question.body'), with: 'Test answer'
    fill_in I18n.translate('helpers.label.link.name'), with: 'My gist'
    fill_in I18n.translate('helpers.label.link.url'), with: 'some_url'

    click_on I18n.translate('helpers.submit.question.create')

    expect(page).to have_content 'Links url is invalid'
  end
end