FactoryGirl.define do
  factory :answer do
    body  FFaker::Lorem.word
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end

  trait :with_user do
    user { create :user }
  end

end
