require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #new' do

    it 'should render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'should save a new answer to the database'
      it 'should redirect to the answers question'
    end

    context 'with invalid attributes' do
      it 'should should not save a new answer to the database'
      it 'should redirect to the edit action'
    end
  end

  describe 'GET #edit' do
    it 'should render edit view'
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'should change answers attributes'
      it 'should redirect to the answers question'
    end

    context 'with invalid attributes' do
      it 'should should not change answer attributes'
      it 'should redirect to the edit action'
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete the answer'
    it 'should redirect to the answer question'
  end
end
