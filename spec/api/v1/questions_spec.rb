
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

      it 'returns 200 status' do
        expect(response).to be_successful
      end

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
  end
end
