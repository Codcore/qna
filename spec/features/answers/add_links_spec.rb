require 'rails_helper'

feature 'User can add links to the answer', %q{
  In order to provide additional info to my answer
  As an answer author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question)}
  given(:gist_url) { 'https://gist.github.com/Codcore/022e6257f0fe09cd0f8f47cdafb48f37' }

  background do
    sign_in user
    visit question_path(question)
    click_on 'add link'
  end

  scenario 'User adds link when asks answer', js: true do
    fill_in I18n.translate('helpers.label.answer.body'), with: 'Test answer'
    fill_in I18n.translate('helpers.label.link.name'), with: 'My gist'
    fill_in I18n.translate('helpers.label.link.url'), with: gist_url

    click_on I18n.translate('helpers.submit.answer.create')

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User adds link when asks answer with invalid url', js: true do
    fill_in I18n.translate('helpers.label.answer.body'), with: 'Test answer'
    fill_in I18n.translate('helpers.label.link.name'), with: 'My gist'
    fill_in I18n.translate('helpers.label.link.url'), with: 'some_url'

    click_on I18n.translate('helpers.submit.answer.create')

    expect(page).to have_content 'Links url is invalid'
  end
end
