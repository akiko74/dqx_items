# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :inventory do
    user
    item
    stock 32
    total_cost 120
  end
end
