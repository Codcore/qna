require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'should render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'should render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'should render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }

    it 'should render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'should save a new question in the database' do
        count = Question.count

        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      
      it 'should redirect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do

      it 'should not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.not_to change(Question, :count)
      end

      it 'should re-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to redirect_to(new_question_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'should change question attributes' do
        patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }
        question.reload

        expect(question.title).to eq 'New title'
        expect(question.body).to eq 'New body'
      end

      it 'should redirect to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'should not change question' do
        old_question = question
        question.reload

        expect(question.title).to eq(old_question.title)
        expect(question.body).to eq(old_question.body)
      end

      it 'should re-render edit view' do
        expect(response).to redirect_to(edit_question_path(question))
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    it 'should delete the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'should redirect to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to question_path
    end
  end
end
