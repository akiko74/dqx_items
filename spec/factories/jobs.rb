FactoryGirl.define do

  factory :saihou, parent: :job do
    name '裁縫'
  end

  factory :weapon_blacksmith, parent: :job do
    name '武器'
  end

end
