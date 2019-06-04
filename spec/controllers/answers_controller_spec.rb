require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  render_views

  let(:user) { create(:user)}
  let(:another_user) { create(:user)}

  let!(:question) { create(:question, author: user) }
  let!(:reward)   { create(:reward, question: question) }
  let!(:answer)   { create(:answer, question: question, author: user) }
  let!(:answer_with_attachment) { create(:answer, :with_files, question: question, author: user) }

  before { login(user) }
  describe 'POST #create' do

    context 'with valid attributes' do
      it 'should save a new answer to the database' do
        question.reload
        answer.reload
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'should tie up logged user as author for answer' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(controller.answer.author_id).to eq user.id
      end

      it 'should render create view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'should should not save a new answer to the database' do

        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.not_to change(question.answers, :count)
      end

      it 'should render create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js

        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do

    context 'with valid attributes' do

      it 'should change answers attributes' do
        patch :update, params: { answer: { body: "New body" }, id: answer }, format: :js
        answer.reload

        expect(answer.body).to eq("New body")
      end

      it 'should render update view' do
        patch :update, params: { answer: attributes_for(:answer), id: answer }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do

      it 'should not change answer attributes' do
        expect { patch :update, params: { answer: attributes_for(:answer, :invalid), id: answer }, format: :js }.not_to change(question.answers, :count)
      end

      it 'should render update view' do
        patch :update, params: { answer: { body: nil }, id: answer }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'by non-author user' do

      before { login(another_user) }

      it 'should not save the answer' do
        expect { patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js }.not_to change(question.answers, :count)
      end

      it 'should redirect to the root url' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response.body).to have_content("You\\'re not authorized for this request")
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'by author' do
      before { login(user) }

      it 'should delete the answer' do
        expect { delete :destroy, params: { id: answer}, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'should render destroy view' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'by non-author user' do
      before { login(another_user) }

      it 'should not delete the answer' do
        expect { delete :destroy, params: { id: answer}, format: :js }.to_not change(question.answers, :count)
      end

      it 'should redirect to the root url' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response.body).to have_content("You\\'re not authorized for this request")
      end
    end
  end

  describe 'POST #best_solution' do
    let(:answer_2) { create(:answer, question: question, author: user) }

    context 'by author' do
      it 'should set answer as a best solution for question' do
        login(user)
        post :best_solution, params: { id: answer }, format: :js
        expect(controller.answer).to be_best_solution
      end

      it 'should re-set answer as a best solution for question' do
        login(user)
        post :best_solution, params: { id: answer }, format: :js
        post :best_solution, params: { id: answer_2 }, format: :js
        expect(answer.reload).to_not be_best_solution
      end

      it 'should render best_solution template' do
        post :best_solution, params: { id: answer }, format: :js
        expect(response).to render_template :best_solution
      end

      it 'should give reward to the best solution answer author' do
        post :best_solution, params: { id: answer }, format: :js
        user.reload
        expect(user.rewards.first).to eq reward
      end
    end

    context 'by non-author' do
      before { login(another_user) }
      it 'should not set answer as a best solution for question' do
        post :best_solution, params: { id: answer }, format: :js
        expect(controller.answer).to_not be_best_solution
      end

      it 'should redirect to the root url' do
        post :best_solution, params: { id: answer }, format: :js
        expect(response.body).to have_content("You\\'re not authorized for this request")
      end
    end
  end
end
