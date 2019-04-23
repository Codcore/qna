require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let!(:answer) { create(:answer) }

  describe 'GET #new' do
    before { get :new, params: { question_id: answer.question } }

    it 'should render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'should save a new answer to the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }}.to change(Answer, :count).by(1)
      end

      it 'should redirect to the answers question path' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'should should not save a new answer to the database' do

        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }}.not_to change(Answer, :count)
      end

      it 'should redirect to the new question answer path' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }

        expect(response).to redirect_to new_question_answer_path(question)
      end
    end
  end

  describe 'GET #edit' do

    it 'should render edit view' do
      get :edit, params: { id: answer }

      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'should change answers attributes' do
        patch :update, params: { answer: { body: "New body" }, id: answer }
        answer.reload

        expect(answer.body).to eq("New body")
      end

      it 'should redirect to the answers question' do
        patch :update, params: { answer: attributes_for(:answer), id: answer }

        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { answer: { body: nil }, id: answer } }

      it 'should not change answer attributes' do
        expect { patch :update, params: { answer: attributes_for(:answer), id: answer } }.not_to change(Answer, :count)
      end

      it 'should redirect to the edit action' do
        expect(response).to redirect_to edit_answer_path(answer)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete the answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'should redirect to the answer question' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to(answer.question)
    end
  end
end