# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :equipment do
    association :user
    association :recipe
    cost { rand(1000000) }
    renkin_count { rand(100) % 4 }
  end
end
