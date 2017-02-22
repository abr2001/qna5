FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@test.com" }

  factory :user do
    email
    password FFaker::Internet.password
  end
end
