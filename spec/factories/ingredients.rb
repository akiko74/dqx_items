# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ingredient do
    association :recipe
    association :item
    number (1..5).to_a.sample
  end
end
