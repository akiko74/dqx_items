# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recipe do
    name { Faker::Lorem.words(1).first }
    level (1..30).to_a.sample
    association :job
    usage_count {rand(50)}
    kana { Faker::Lorem.words(1).first }
  end
end
