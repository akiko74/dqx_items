# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :inventory do
    association :user
    association :item
    stock { rand(100) }
    total_cost { rand(10000) }
  end
end
