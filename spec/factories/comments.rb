FactoryBot.define do
  factory :comment do
    comment { 'MyComment' }

    trait :invalid do
      comment { nil }
    end
  end
end
