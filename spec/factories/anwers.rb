FactoryGirl.define do
  factory :answer do
    body  FFaker::Lorem.word
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end

end
