require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Codcore/022e6257f0fe09cd0f8f47cdafb48f37' }

  scenario 'User adds link when asks question' do
    sign_in user
    visit new_question_path

    fill_in I18n.translate('helpers.label.question.title'), with: 'Test question'
    fill_in I18n.translate('helpers.label.question.body'), with: 'Test description'

    fill_in I18n.translate('helpers.label.link.name'), with: 'My gist'
    fill_in I18n.translate('helpers.label.link.url'), with: gist_url

    click_on I18n.translate('helpers.submit.question.create')
    click_on 'Test question'
    expect(page).to have_link 'My gist', href: gist_url

  end
end