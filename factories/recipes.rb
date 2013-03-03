# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recipe do
    name { Faker::Lorem.words(1).first }
    association :job
    level (1..30).to_a.sample
  end
end
