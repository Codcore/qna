require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  ThinkingSphinx::Test.run do
    describe 'POST #create' do
      let(:search_service) { Services::SphinxSearch.new }

      it 'returns http success' do
        post :create, params: { search_text: 'search text', type: 'question' }
        expect(response).to have_http_status(:success)
      end

      it 'should render create template' do
        post :create, params: { search_text: 'search text', type: 'question' }
        expect(response).to render_template(:create)
      end

      context 'it calls Services::SphinxSearch with right params' do

        it 'for "question" search' do
          allow(Services::SphinxSearch).to receive(:new).and_return(search_service)
          expect(search_service).to receive(:get_search_results).and_call_original
          expect(Question).to receive(:search).with('search text', page: 1, per_page: 10)

          post :create, params: { search_text: 'search text', type: 'question' }
        end

        it 'for "question" search' do
          allow(Services::SphinxSearch).to receive(:new).and_return(search_service)
          expect(search_service).to receive(:get_search_results).and_call_original
          expect(Answer).to receive(:search).with('search text', page: 1, per_page: 10)

          post :create, params: { search_text: 'search text', type: 'answer' }
        end

        it 'for "commentary" search' do
          allow(Services::SphinxSearch).to receive(:new).and_return(search_service)
          expect(search_service).to receive(:get_search_results).and_call_original
          expect(Commentary).to receive(:search).with('search text', page: 1, per_page: 10)

          post :create, params: { search_text: 'search text', type: 'commentary' }
        end

        it 'for "user" search' do
          allow(Services::SphinxSearch).to receive(:new).and_return(search_service)
          expect(search_service).to receive(:get_search_results).and_call_original
          expect(User).to receive(:search).with('search text', page: 1, per_page: 10)

          post :create, params: { search_text: 'search text', type: 'user' }
        end

        it 'for "total" search' do
          allow(Services::SphinxSearch).to receive(:new).and_return(search_service)
          expect(search_service).to receive(:get_search_results).and_call_original
          expect(ThinkingSphinx).to receive(:search).with('search text', page: 1, per_page: 10)

          post :create, params: { search_text: 'search text' }
        end

      end
    end
  end
end
