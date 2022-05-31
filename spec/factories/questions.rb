FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
    trait :with_author do
      author { build(:user) }
    end
  end

  trait :with_answers do
    after(:create) do |q|
      create_list(:answer, 3, :with_author, question_id: q.id)
    end
  end

end
