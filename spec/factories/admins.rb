# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin do
    email {Faker::Internet.email}
    password "p@ssp0rd"
    password_confirmation { password }
    created_at { 1.weeks.ago }
    updated_at { 1.weeks.ago }
  end
end
