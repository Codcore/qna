require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/answers/{id}' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/answers/1' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer_with_links_and_comments, :with_files, question: question) }
      let(:answer_response) { json['answer'] }

      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains question object' do
        expect(answer_response['question']['id']).to eq answer.question_id
      end

      it 'contains author object' do
        expect(answer_response['author']['id']).to eq answer.author_id
      end

      it 'contains links' do
        links = answer_response['links']
        expect(links.count).to eq answer.links.count

        %w[id name url created_at updated_at].each do |attr|
          expect(links.first[attr]).to eq answer.links.first.send(attr).as_json
        end
      end

      it 'contains links for attached files' do
        files = answer_response['files']
        expect(files.count).to eq answer.files.count

        files.each_with_index do |file, index|
          expect(file).to eq url_for(answer.files[index])
        end
      end

      it 'contains commentaries' do
        commentaries = answer_response['commentaries']
        expect(commentaries.count).to eq answer.commentaries.count

        %w[id body created_at updated_at].each do |attr|
          expect(commentaries.first[attr]).to eq answer.commentaries.first.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/question/{question_id}/answers/' do
    let!(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers/" }
    end

    context 'authorized' do
      it 'returns 201 status' do
        post "/api/v1/questions/#{question.id}/answers/", params: { answer: attributes_for(:answer), question_id: question,
                                                                    access_token: access_token.token }
        expect(response).to have_http_status :created
      end

      it 'redirects to the newly created answer' do
        post "/api/v1/questions/#{question.id}/answers/", params: { answer: attributes_for(:answer), question_id: question,
                                             access_token: access_token.token }
        expect(response.headers['Location']).to eq api_v1_answer_url(Answer.last)
      end

      it 'creates an answer' do
        expect do
          post "/api/v1/questions/#{question.id}/answers/", params: { answer: attributes_for(:answer), question_id: question,
                                               access_token: access_token.token }
        end.to change(Answer, :count).by(1)
      end

      context 'for invalid answer' do

        it 'does not create answer' do
          expect do
            post "/api/v1/questions/#{question.id}/answers/", params: { answer: { body: '' }, question_id: question,
                                                 access_token: access_token.token }
          end.to_not change(Answer, :count)
        end

        it 'returns 400 status' do
          post "/api/v1/questions/#{question.id}/answers/", params: { answer: { body: '' }, question_id: question,
                                               access_token: access_token.token }
          expect(response).to have_http_status :bad_request
        end
      end
    end
  end
end