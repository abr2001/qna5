FactoryGirl.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'spec_helper.rb')) }
  end

  trait :for_question do
    attachable { create :question }
  end

end
