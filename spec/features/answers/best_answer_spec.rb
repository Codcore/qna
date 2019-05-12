require 'rails_helper'

feature 'User can choose best answer for question', %q{
  In order to show to others user the best solution for my question
  As a author of a question
  I'd like to choose the best question
} do

  given!(:author) { create(:user) }
  given(:non_author_user) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:reward)   { create(:reward, :for_question, rewardable: question, question: question) }
  given!(:answer_1) { create(:answer, question: question, author: author) }
  given!(:answer_2) { create(:answer, question: question, author: non_author_user) }


  describe 'Author' do
    describe 'can select a best answer for question', js: true do
      before do
        sign_in author
        visit question_path(question)

        within(".answers #answer-#{answer_1.id}") do
          accept_confirm do
            click_on I18n.translate('answers.answer.best_solution_button')
          end
        end
      end

      scenario 'answer changes its style' do
        within(".answers #answer-#{answer_1.id}") do
          expect(page).to have_content I18n.translate('answers.answer.best_solution_button').upcase
        end
      end

      scenario 'best solution answer moves to top of the answers list' do
        within(".answers") do
          expect(first('.answer')).to have_content(answer_1.body)
        end
      end

      scenario 'reward is given to answer author for a question with reward' do
        author.reload
        sleep 3
        visit rewards_index_path
        expect(page).to have_content(reward.name)
        expect(page).to have_content(reward.question.title)
      end

      scenario 'can re-select a best answer for question' do
        within(".answers #answer-#{answer_2.id}") do
          accept_confirm do
            click_on I18n.translate('answers.answer.best_solution_button')
          end
        end

        within(".answers #answer-#{answer_2.id}") do
          expect(page).to have_content I18n.translate('answers.answer.best_solution_button').upcase
        end

        within(".answers") do
          expect(first('.answer')).to have_content(answer_2.body)
        end
      end
    end
  end

  describe 'Non-author user' do
    let!(:best_solution_answer) { create(:answer, question: question, best_solution: true) }

    before do
      sign_in non_author_user
      visit question_path(question)
    end

    scenario 'cannot select a best answer for question' do
      expect(page).not_to have_content I18n.translate('answers.answer.best_solution_button')
    end

    scenario 'can see best answer at the top of all answers' do
      within(".answers #answer-#{best_solution_answer.id}") do
        expect(page).to have_content I18n.translate('answers.answer.best_solution_button').upcase
      end

      within(".answers") do
        expect(first('.answer')).to have_content(best_solution_answer.body)
      end
    end
  end

  describe 'Unauthenticated user' do
    let!(:best_solution_answer) { create(:answer, question: question, best_solution: true) }

    before do
      visit question_path(question)
    end

    scenario 'cannot select a best answer for question' do
      expect(page).not_to have_content I18n.translate('answers.answer.best_solution_button')
    end

    scenario 'can see best answer at the top of all answers' do
      within(".answers #answer-#{best_solution_answer.id}") do
        expect(page).to have_content I18n.translate('answers.answer.best_solution_button').upcase
      end

      within(".answers") do
        expect(first('.answer')).to have_content(best_solution_answer.body)
      end
    end
  end
end