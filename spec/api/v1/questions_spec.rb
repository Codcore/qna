require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/questions/' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2)}
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(json['questions'].first[attr]).to eq questions.first.send(attr).as_json
        end
      end

      it 'contains author object' do
        expect(question_response['author']['id']).to eq question.author_id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(11)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { json.first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(json['questions'].first[attr]).to eq questions.first.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/{id}' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions/1' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question_with_links_and_comments, :with_files) }
      let(:question_response) { json['question'] }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'contains links' do
        links = question_response['links']
        expect(links.count).to eq question.links.count

        %w[id name url created_at updated_at].each do |attr|
          expect(links.first[attr]).to eq question.links.first.send(attr).as_json
        end
      end

      it 'contains links for attached files' do
        files = question_response['files']
        expect(files.count).to eq question.files.count

        files.each_with_index do |file, index|
          expect(file).to eq url_for(question.files[index])
        end
      end

      it 'contains commentaries' do
        commentaries = question_response['commentaries']
        expect(commentaries.count).to eq question.commentaries.count

        %w[id body created_at updated_at].each do |attr|
          expect(commentaries.first[attr]).to eq question.commentaries.first.send(attr).as_json
        end
      end

      it 'contains author object' do
        expect(question_response['author']['id']).to eq question.author_id
      end
    end
  end

  describe 'POST /api/v1/questions/' do
    let!(:question) { create(:question) }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { '/api/v1/questions/' }
    end

    context 'authorized' do
      it 'returns 201 status' do
        post '/api/v1/questions/', params: { question: attributes_for(:question),
                                             access_token: access_token.token }
        expect(response).to have_http_status :created
      end

      it 'redirects to the newly created question' do
        post '/api/v1/questions/', params: { question: attributes_for(:question),
                                             access_token: access_token.token }
        expect(response.headers['Location']).to eq api_v1_question_url(Question.last)
      end

      it 'creates a question' do
        expect do
          post '/api/v1/questions/', params: { question: attributes_for(:question),
                                               access_token: access_token.token }
        end.to change(Question, :count).by(1)
      end

      context 'for invalid question' do

        it 'does not create question' do
          expect do
            post '/api/v1/questions/', params: { question: { body: 'Some test body for question', title: ''},
                                                 access_token: access_token.token }
          end.to_not change(Question, :count)
        end

        it 'returns 422 status' do
          post '/api/v1/questions/', params: { question: { body: 'Some test body for question', title: ''},
                                               access_token: access_token.token }
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/{id}' do
    let!(:access_token) { create(:access_token) }
    let!(:question) { create(:question, author_id: access_token.resource_owner_id) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do
      it 'returns 200 status when question successfully updated' do
        patch "/api/v1/questions/#{question.id}", params: { question: attributes_for(:question),
                                                            access_token: access_token.token }
        expect(response).to have_http_status :ok
      end

      it 'changes question' do
        patch "/api/v1/questions/#{question.id}", params: { question: { body: 'Some test body for question', title: 'Some test title'},
                                                            access_token: access_token.token }
        question.reload
        expect(question.body).to eq 'Some test body for question'
        expect(question.title).to eq 'Some test title'
      end

      context 'for invalid question' do

        it 'returns 422 status' do
          patch "/api/v1/questions/#{question.id}", params: { question: { body: 'Some test body for question', title: ''},
                                                              access_token: access_token.token }
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'does not change question' do
          patch "/api/v1/questions/#{question.id}", params: { question: attributes_for(:question),
                                                              access_token: access_token.token }
          question.reload
          expect(assigns(:question).body).to eq question.body
          expect(assigns(:question).title).to eq question.title
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/{id}' do
    let!(:access_token) { create(:access_token) }
    let!(:question) { create(:question, author_id: access_token.resource_owner_id) }


    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do
      it 'deletes question' do
        expect { delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token } }.to change(Question, :count).by (-1)
      end

      it 'return 200 status' do
        delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }

        expect(response).to have_http_status :ok
      end
    end
  end
end