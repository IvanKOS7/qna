require 'rails_helper'

RSpec.describe Services::FindForOauth do
  let!(:user) { create(:user) }
  let!(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
  subject { Services::FindForOauth.new(auth) }
  context 'user already authorized' do
    it 'returns the user' do
      user.authorizations.create(provider: 'facebook', uid: '123456')
      service = Services::FindForOauth.new(auth)
      expect(subject.call).to eq user
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'faceebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { subject.call }.to_not change(User, :count)
        end

        it 'creates authorizations for user' do
          expect { subject.call }.to change(user.authorizations, :count).by(1)
        end

        it 'creates auth with provider and uid' do
          user = subject.call
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end

      context 'user does not exist' do
        let!(:auth) { OmniAuth::AuthHash.new(provider: 'faceebook', uid: '123456', info: { email: user.email }) }
        it 'creates new user' do
          expect { subject.call }.to change(User, :count).by(1)
        end
        it 'returns new user' do
          expect { subject.call }.to be_a(User)
        end

        it 'fills user email' do
          user = subject.call
          expect(user.email).to eq auth.email
        end

        it 'creates authorization for user' do
          user = subject.call
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = subject.call.authorizations.first
        end
      end
    end
  end
end
