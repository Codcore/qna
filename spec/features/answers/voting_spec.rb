require 'rails_helper'

feature 'User can vote for answer', %q{
  In order to determine best answers
  As a user
  I'd like to be able to vote for answers
} do

  let(:author)       { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question)     { create(:question) }
  let!(:answer_1)     { create(:answer, question: question, author: author) }
  let!(:answer_2)     { create(:answer, question: question, author: another_user) }

  scenario 'User can vote for answers of another users', js: true do
    sign_in author
    visit question_path(question)

    within "#answer-#{answer_2.id}" do
      expect(page).to have_css ".answer-upvote-link"
      expect(page).to have_css ".answer-downvote-link"
    end

    page.find("#answer-#{answer_2.id} .answer-upvote-link").click

    within "#answer-#{answer_2.id} .answer-score" do
      expect(page).to have_content '1'
    end

    page.find("#answer-#{answer_2.id} .answer-downvote-link").click

    within "#answer-#{answer_2.id} .answer-score" do
      expect(page).to have_content '0'
    end

    page.find("#answer-#{answer_2.id} .answer-downvote-link").click

    within "#answer-#{answer_2.id} .answer-score" do
      expect(page).to have_content '-1'
    end
  end

  scenario 'Guest can not vote for answers' do
    visit question_path(question)

    within "#answer-#{answer_1.id}" do
      expect(page).not_to have_css ".answer-upvote-link"
      expect(page).not_to have_css ".answer-downvote-link"
    end
  end

  scenario 'User can not vote for his own answer' do
    sign_in author
    visit question_path(question)

    within "#answer-#{answer_1.id}" do
      expect(page).not_to have_css ".answer-upvote-link"
      expect(page).not_to have_css ".answer-downvote-link"
    end
  end

  scenario 'User can not up vote for answer twice or more times', js: true do
    sign_in author
    visit question_path(question)

    page.find("#answer-#{answer_2.id} .answer-upvote-link").click
    page.find("#answer-#{answer_2.id} .answer-upvote-link").click

    within "#answer-#{answer_2.id} .answer-score" do
      expect(page).to have_content '1'
    end
  end

  scenario 'User can not down vote for answer twice or more times', js: true do
    sign_in author
    visit question_path(question)

    page.find("#answer-#{answer_2.id} .answer-downvote-link").click
    page.find("#answer-#{answer_2.id} .answer-downvote-link").click

    within "#answer-#{answer_2.id} .answer-score" do
      expect(page).to have_content '-1'
    end
  end
end