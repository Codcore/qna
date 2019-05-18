require 'rails_helper'

feature 'User can vote for question', %q{
  In order to determine best questions
  As a user
  I'd like to be able to vote for questions
} do

  let(:author)       { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question)     { create(:question, author: another_user) }
  let!(:author_question)     { create(:question, author: author) }

  scenario 'User can vote for questions of another users', js: true do
    sign_in author
    visit question_path(question)

    within ".question" do
      expect(page).to have_css ".question-upvote-link"
      expect(page).to have_css ".question-downvote-link"
    end

    page.find(".question .question-upvote-link").click

    within ".question .question-score" do
      expect(page).to have_content '1'
    end

    page.find(".question .question-downvote-link").click

    within ".question .question-score" do
      expect(page).to have_content '0'
    end

    page.find(".question .question-downvote-link").click

    within ".question .question-score" do
      expect(page).to have_content '-1'
    end
  end

  scenario 'Guest can not vote for questions' do
    visit question_path(question)

    within "#question-#{question.id}" do
      expect(page).not_to have_css ".question-upvote-link"
      expect(page).not_to have_css ".question-downvote-link"
    end
  end

  scenario 'User can not vote for his own question' do
    sign_in author
    visit question_path(author_question)

    within "#question-#{author_question.id}" do
      expect(page).not_to have_css ".question-upvote-link"
      expect(page).not_to have_css ".question-downvote-link"
    end
  end

  scenario 'User can not up vote for question twice or more times', js: true do
    sign_in author
    visit question_path(question)

    page.find("#question-#{question.id} .question-upvote-link").click
    page.find("#question-#{question.id} .question-upvote-link").click

    within "#question-#{question.id} .question-score" do
      expect(page).to have_content '1'
    end
  end

  scenario 'User can not down vote for answer twice or more times', js: true do
    sign_in author
    visit question_path(question)

    page.find("#question-#{question.id} .question-downvote-link").click
    page.find("#question-#{question.id} .question-downvote-link").click

    within "#question-#{question.id} .question-score" do
      expect(page).to have_content '-1'
    end
  end
end