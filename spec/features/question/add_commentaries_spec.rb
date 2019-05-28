require 'rails_helper'

feature 'User can add commentaries to the question', %q{
  In order to discuss question
  As an user
  I'd like to be able to add comments
} do

  given(:author) { create(:user) }
  given(:guest) { create(:user) }
  given!(:question) { create(:question, author: author) }

  scenario 'User adds commentary', :js do
    sign_in author
    visit question_path(question)

    within ".question" do
      expect(page).to have_content 'Add commentary'
      find(".commentary-button").click
      fill_in 'Commentary', with: 'Question commentary with good length'
      click_on 'Add commentary'
    end

    expect(page).to have_content 'Question commentary with good length'
  end

  scenario 'User adds commentary with not enough length', :js do
    sign_in author
    visit question_path(question)

    within ".question" do
      expect(page).to have_content 'Add commentary'
      find(".commentary-button").click
      fill_in 'Commentary', with: 'Question commentary'
      click_on 'Add commentary'
    end

    expect(page).not_to have_content 'Question commentary'
    expect(page).to have_content 'Errors found:'
  end

  scenario 'Guest can not add commentary' do
    visit question_path(question)

    within ".question" do
      expect(page).not_to have_content 'Add commentary'
    end
  end

  describe 'Deleting commentaries', :js do
    before { create(:commentary, body: 'Test commentary with enough length', commentable: question, author: author) }

    scenario 'Author can delete commentaries' do
      sign_in author
      visit question_path(question)

      within ".question" do
        accept_confirm do
          find('.delete-commentary-link').click
        end
      end

      expect(page).not_to have_content 'Test commentary with enough length'
    end

    scenario 'Non-author can not delete commentaries' do
      sign_in guest
      visit question_path(question)

      within ".question" do
        expect(page).not_to have_link('.delete-commentary-link')
      end
    end

    scenario 'Guest can not delete commentaries' do
      visit question_path(question)

      within ".question" do
        expect(page).not_to have_link('.delete-commentary-link')
      end
    end
  end

  context "multiple sessions", js: true do
    scenario "commentary appears on another users's page" do
      Capybara.using_session('user') do
        sign_in guest
        visit question_path(question)
      end

      Capybara.using_session('author') do
        sign_in author
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('author') do
        visit question_path(question)

        within ".question" do
          find(".commentary-button").click
          fill_in 'Commentary', with: 'Answer commentary with enough length'
          click_on 'Add commentary'
        end
      end

      Capybara.using_session('user') do
        within ".question" do
          expect(page).to have_content 'Answer commentary with enough length'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Answer commentary with enough length'

        expect(page).not_to have_link '.delete-commentary-link'
      end
    end
  end
end