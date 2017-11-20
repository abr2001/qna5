FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@test.com" }

  factory :user do
    email
    password FFaker::Internet.password
    before(:create) do |user|
      user.skip_confirmation!
    end
  end
end
