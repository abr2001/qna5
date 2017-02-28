FactoryGirl.define do
  factory :question do
    title FFaker::Lorem.word
    body  FFaker::Lorem.word
  end

  factory :invalid_question, class: 'Question' do
    title FFaker::Lorem.word
    body  nil
  end

end
