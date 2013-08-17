# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    name { Faker::Lorem.words(1).first }
    kana { Faker::Lorem.words(1).first }
    price { rand(10000000) }
  end
end
