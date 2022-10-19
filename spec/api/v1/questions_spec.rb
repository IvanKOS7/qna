
require 'rails_helper'
require 'logger'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => 'application/json',
                    "ACCEPT" => 'application/json'} }
  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/profiles/me' }
      let(:method) { :get }
    end
    context 'authorized' do
      let(:me) { create(:user, :admin) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:questions) { create_list(:question, 3) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }
      before do
        get '/api/v1/questions', params: {}, headers:   { "CONTENT_TYPE" => 'application/json',
                                                             "ACCEPT" => 'application/json',
                                                             "Authorization" => 'Bearer ' + access_token.token}
      end

      it_behaves_like 'API Successefuly Response'

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq questions.first.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user_id']).to eq question.user_id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'] }

        it 'returns list of answers' do
          expect(answer_response.size).to eq 3
        end

        it 'returns all public fields' do
          %w[id title body user_id created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq questions.first.send(attr).as_json
          end
        end
      end
    end

    describe 'GET /api/v1/questions/:id' do
      it_behaves_like 'API Authorizable' do
        let!(:api_path) { '/api/v1/questions/:id' }
        let!(:method) { :get }
      end

      let!(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:comment) { create(:comment, question: question) }
      let(:link) { create(:link, question: question) }
      let(:file) { create(:file, question: question) }
      before do
        get "/api/v1/questions/#{question.id}", params: {}, headers:   { "CONTENT_TYPE" => 'application/json',
                                                             "ACCEPT" => 'application/json',
                                                             "Authorization" => 'Bearer ' + access_token.token}
      end


      it 'contains questiion fields' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(json['question'][attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains question comment, files, links..' do
        %w[comments files links].each do |field|
          expect(json['question'][field].size).to eq question.send(field).size
        end
      end
    end

    describe 'POST /api/v1/questions/' do
      it_behaves_like 'API Authorizable' do
        let!(:api_path) { '/api/v1/questions/' }
        let!(:method) { :post }
      end

      let!(:access_token) { create(:access_token) }

      before do
        post "/api/v1/questions/", params: { title: 'Test', body: 'Test7' }, headers:   {"ACCEPT" => 'application/json',
                                                                                         "Authorization" => 'Bearer ' + access_token.token }

       end

      it 'contains new question ' do
        expect(json['question']['id']).to eq Question.all.first.id
      end
    end

    describe 'PATCH /api/v1/questions/:id' do
      let!(:question) {create(:question)}
      it_behaves_like 'API Authorizable' do
        let!(:api_path) { '/api/v1/questions/:id' }
        let!(:method) { :patch }
      end

      let!(:access_token) { create(:access_token) }

      before do
        patch "/api/v1/questions/#{question.id}", params: { title: 'Title2', body: 'Body2' }, headers:   {"ACCEPT" => 'application/json',
                                                                                         "Authorization" => 'Bearer ' + access_token.token }

       end

      it 'return question with new params' do
        expect(json['question']['title']).to eq 'Title2'
      end
    end

    describe 'DELETE /api/v1/questions/:id' do
      let!(:question) {create(:question)}
      it_behaves_like 'API Authorizable' do
        let!(:api_path) { '/api/v1/questions/:id' }
        let!(:method) { :delete }
      end

      let!(:access_token) { create(:access_token) }

      before do
        delete "/api/v1/questions/#{question.id}", params: {}, headers:   {"ACCEPT" => 'application/json',
                                                                                         "Authorization" => 'Bearer ' + access_token.token }

        end

      it 'question deleted' do
        expect(Question.all).to_not include :question
      end
    end
  end
end
