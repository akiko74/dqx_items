# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email {Faker::Internet.email}
    password "p@ssw0rd"
    password_confirmation { password }
  end
end
