FactoryGirl.define do

  factory :nusutto_ware, parent: :equipment do
    association :user
    association :recipe, factory: :nusutto_ware_recipe
    cost 300
    renkin_count 0
  end

end
