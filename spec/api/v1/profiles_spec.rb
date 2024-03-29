require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => 'application/json',
                    "ACCEPT" => 'application/json'} }
  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/profiles/me' }
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user, :admin) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before do
        do_request :get, '/api/v1/profiles/me', (params: {}, headers:   { "CONTENT_TYPE" => 'application/json',
                                                             "ACCEPT" => 'application/json',
                                                             "Authorization" => 'Bearer ' + access_token.token})
      end

      it_behaves_like 'API Successefuly Response'

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'doesnt returns privat fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not eq have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/' do
    it_behaves_like 'API Authorizable' do
      let!(:api_path) { '/api/v1/profiles/' }
      let!(:method) { :get }
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let!(:access_token) { create(:access_token) }
      before do
        get '/api/v1/profiles/', params: {}, headers:   { "CONTENT_TYPE" => 'application/json',
                                                          "ACCEPT" => 'application/json',
                                                          "Authorization" => 'Bearer ' + access_token.token }
      end

      it_behaves_like 'API Successefuly Response'

      it 'returns user fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[0][attr]).to eq users[0].send(attr).as_json
        end
      end

      it 'right users count without resource owner' do
        expect(json.size).to eq User.count - 1
      end

      it 'doesnt returns privat fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not eq have_key(attr)
        end
      end
    end
  end
end
