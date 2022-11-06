FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    sequence(:resource_owner_id) { create(:user, :admin).id }
    association :application, factory: :oauth_application
    expires_in { 2.hours }
    scopes { 'read' }
  end
end
