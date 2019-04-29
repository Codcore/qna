require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  let!(:question) { create(:question, author: user) }

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

    before { login(user) }
    before { get :new }

    it 'should render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'should render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'should save a new question in the database' do
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

      it 'should render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do

    context 'with valid attributes' do
      before { login(user) }
      before { patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } } }

      it 'should change question attributes' do
        question.reload

        expect(question.title).to eq 'New title'
        expect(question.body).to eq 'New body'
      end

      it 'should tie up logged user as author for question' do
        expect(question.author_id).to eq user.id
      end

      it 'should redirect to the updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { login(user) }
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'should not change question' do
        old_question = question
        question.reload

        expect(question.title).to eq(old_question.title)
        expect(question.body).to eq(old_question.body)
      end

      it 'should render edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'by non-author user' do

      before { login(another_user) }

      it 'should not save the question' do
        expect { patch :update, params: { id: question, question: attributes_for(:question) } }.not_to change(Question, :count)
      end

      it 'should have status 403 Forbidden' do
        patch :update, params: { id: question, question: attributes_for(:question) }

        expect(response).to have_http_status(403)
      end
    end
  end


  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question, author: user) }

    it 'should delete the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'should redirect to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end

    context 'by non-author user' do
      before { login(another_user) }

      it 'should not delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'should have status 403 Forbidden' do
        delete :destroy, params: { id: question }

        expect(response).to have_http_status(403)
      end
    end
  end
end

