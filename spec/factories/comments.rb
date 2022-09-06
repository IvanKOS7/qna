FactoryBot.define do
  factory :comment do
    comment { "MyComment" }
    question nil

    trait :invalid do
      comment { nil }
    end
  end
end
