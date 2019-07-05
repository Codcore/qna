require 'sphinx_helper'

feature 'User can search for information', %q{
  In order to find needed information
  As a User
  I'd like to be able to search for the information
} do

  given(:user) { create(:user, email: 'user@email.com') }
  given!(:question) { create(:question, author: user, title: 'Some question from user') }
  given!(:answer)   { create(:answer, question: question, body: 'Test answer body') }
  given!(:question_commentary)   { create(:commentary, commentable: question, body: 'Test commentary body for question') }
  given!(:answer_commentary)   { create(:commentary, commentable: answer, body: 'Test commentary body for answer') }

  scenario 'User can search for the questions', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'user'
      choose 'Questions'
      click_on 'Search'

      expect(page).to have_content('Some question from user')
    end
  end

  scenario 'User can search for the answers', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'answer body'
      choose 'Answers'
      click_on 'Search'

      expect(page).to have_content('Some question from user')
    end
  end

  scenario 'User can search for the commentaries for question', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'for question'
      choose 'Commentaries'
      click_on 'Search'

      expect(page).to have_content('Some question from user')
    end
  end

  scenario 'User can search for the commentaries for answer', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'for answer'
      choose 'Commentaries'
      click_on 'Search'

      expect(page).to have_content('Some question from user')
    end
  end

  scenario 'User can search for the users', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'user'
      choose 'Users'
      click_on 'Search'

      expect(page).to have_content(user.email)
    end
  end
end