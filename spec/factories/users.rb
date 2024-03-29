FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
  end

  factory :another_user, class: User do
    email { '1111@test.com' }
    password { '12345678' }
    password_confirmation { '12345678' }
  end

  trait :admin do
    admin { true }
  end
end
