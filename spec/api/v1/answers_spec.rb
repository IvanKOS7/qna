require 'rails_helper'
require 'logger'

describe 'Answers API', type: :request do
  let(:answer) { create(:answer) }
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  describe 'GET /api/v1/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :get }
    end
    context 'authorized' do
      let(:me) { create(:user, :admin) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get "/api/v1/answers/#{answer.id}", params: {}, headers:   { 'CONTENT_TYPE' => 'application/json',
                                                                     'ACCEPT' => 'application/json',
                                                                     'Authorization' => 'Bearer ' + access_token.token }
      end

      it_behaves_like 'API Successefuly Response'

      context 'one answer' do
        let!(:comment) { create(:comment, commentable_id: answer.id) }
        let!(:link) { create(:link, linkable_id: answer.id) }
        # let!(:file) { answer.files.attach("rails_helper.rb") }
        before do
          get "/api/v1/answers/#{answer.id}", params: {}, headers:   { 'CONTENT_TYPE' => 'application/json',
                                                                       'ACCEPT' => 'application/json',
                                                                       'Authorization' => 'Bearer ' + access_token.token }
        end

        it 'return answer' do
          expect(json['answer']['id']).to eq answer.id
        end

        it 'contains answer comment,links..' do
          %w[comments links].each do |field|
            expect(json['answer'][field]).to eq answer.send(field).as_json
          end
        end
      end
    end

    describe 'POST /api/v1/question/:id/answers/' do
      it_behaves_like 'API Authorizable' do
        let(:api_path) { '/api/v1/questions/:id/answers/' }
        let(:method) { :post }
      end
      context 'authorized' do
        let!(:question) { create(:question) }
        let(:access_token) { create(:access_token) }
        before do
          post "/api/v1/questions/#{question.id}/answers/", params: { body: 'TestAnswer' }, headers:   {
            'ACCEPT' => 'application/json',
            'Authorization' => 'Bearer ' + access_token.token
          }
        end

        it 'return new answer for question' do
          expect(json['answer']['body']).to eq 'TestAnswer'
        end
      end

      describe 'PATCH /api/v1/answers/:id' do
        it_behaves_like 'API Authorizable' do
          let(:api_path) { '/api/v1/answers/:id' }
          let(:method) { :patch }
        end
        context 'authorized' do
          let!(:answer) { create(:answer) }
          let(:access_token) { create(:access_token) }
          before do
            patch "/api/v1/answers/#{answer.id}/", params: { body: 'NewAnswer' }, headers:   {
              'ACCEPT' => 'application/json',
              'Authorization' => 'Bearer ' + access_token.token
            }
          end

          it 'return new answer for question' do
            expect(json['answer']['body']).to eq 'NewAnswer'
          end
        end
      end

      describe 'Delete /api/v1/answers/:id' do
        it_behaves_like 'API Authorizable' do
          let(:api_path) { '/api/v1/answers/:id' }
          let(:method) { :delete }
        end
        context 'authorized' do
          let!(:answer) { create(:answer) }
          let(:access_token) { create(:access_token) }
          before do
            delete "/api/v1/answers/#{answer.id}/", params: {}, headers:   {
              'ACCEPT' => 'application/json',
              'Authorization' => 'Bearer ' + access_token.token
            }
          end

          it 'return new answer for question' do
            expect(Answer.all).to_not include :answer
          end
        end
      end
    end
  end
end
