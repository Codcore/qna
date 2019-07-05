require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  ThinkingSphinx::Test.run do
    describe 'POST #create' do
      before do
        post :create, params: { search: 'search text', type: 'question' }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'should render create template' do
        expect(response).to render_template(:create)
      end
    end
  end
end
