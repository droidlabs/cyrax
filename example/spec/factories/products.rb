# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    vendor "MyString"
    model "MyString"
    description "MyText"
    price_in_cents 1
  end
end
