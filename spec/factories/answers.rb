FactoryBot.define do
  factory :answer do
    body { 'MyAnswer' }
    question nil

    trait :invalid do
      body { nil }
    end
    trait :with_author do
      author { build(:user) }
    end
  end
end
