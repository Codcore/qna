require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }

  describe 'POST #create' do
    context 'by user' do
      before { login(user) }

      it 'should subscribe user for questions updates' do
        expect { post :create, params: { question_id: question } }.to change(question.subscribers, :count).by(1)
      end
    end

    context 'by guest' do
      it 'should not subscribe user for questions updates' do
        expect { post :create, params: { question_id: question } }.to_not change(question.subscribers, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, user: user, question: question) }
    let!(:another_user) { create(:user) }

    context 'by user' do
      before { login(user) }

      it 'should unsubscribe user for questions updates' do
        expect { delete :destroy, params: { question_id: question, id: 0 } }.to change(question.subscribers, :count).by(-1)
      end
    end

    context 'by guest' do
      it 'should not unsubscribe user for questions updates' do
        expect { delete :destroy, params: { question_id: question, id: 0 } }.to_not change(question.subscribers, :count)
      end
    end

    context 'by non-author user' do
      before { login(another_user) }

      it 'should not unsubscribe user for questions updates' do
        expect { delete :destroy, params: { question_id: question, id: 0 } }.to_not change(question.subscribers, :count)
      end
    end
  end
end
