# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    name { Faker::Lorem.words(1).first }
  end
end
