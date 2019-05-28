require 'rails_helper'

RSpec.describe CommentariesController, type: :controller do
  render_views

  let(:user)     { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer)   { create(:answer, author: user) }

  describe 'POST #create' do
    it 'should add commentary to the commentable resource' do
      login user

      expect { post :create, params: { question_id: question.id, commentary: { body: 'New comment for question' } }, format: :js }.to change(question.commentaries, :count).by(1)
    end

    it 'should render create view' do
      login user
      post :create, params: { question_id: question.id, commentary: { body: 'New comment for question' } }, format: :js

      expect(response).to render_template :create
    end
  end

  describe 'DELETE #destroy' do
    let!(:commentary) { create(:commentary, author: user) }

    it 'should destroy commentary of the commentable resource' do
      login user

      expect { delete :destroy, params: { id: commentary }, format: :js }.to change(Commentary, :count).by(-1)
    end

    it 'should render create view' do
      login user
      delete :destroy, params: { id: commentary }, format: :js

      expect(response).to render_template :destroy
    end
  end
end
