FactoryGirl.define do
  factory :attachment do
    file "MyString"
    attachable 1
    attachable_type "MyString"
  end
end
