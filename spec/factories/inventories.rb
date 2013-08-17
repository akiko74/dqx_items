FactoryGirl.define do

  factory :my_small_shell, parent: :inventory do
    association :user
    item { |inventory|
      Item.find_by_name('小さなこうら') || FactoryGirl.create(:small_shell)
    }
    stock 3
    total_cost 750
  end

  factory :my_fairy_powder, parent: :inventory do
    association :user
    item { |inventory|
      Item.find_by_name('ようせいの粉') || FactoryGirl.create(:fairy_powder)
    }
    stock 4
    total_cost 400
  end

  factory :my_ayakashi_sou, parent: :inventory do
    association :user
    item { |inventory|
      Item.find_by_name('あやかしそう') || FactoryGirl.create(:ayakashi_sou)
    }
    stock 10
    total_cost 2900
  end

  factory :my_cotton_sou, parent: :inventory do
    association :user
    item { |inventory|
      Item.find_by_name('コットン草') || FactoryGirl.create(:cotton_sou)
    }
    stock 3
    total_cost 360
  end

  factory :my_silver_stone, parent: :inventory do
    association :user
    item { |inventory|
      Item.find_by_name('ぎんのこうせき') || FactoryGirl.create(:silver_stone)
    }
    stock 66
    total_cost 15840
  end

  factory :my_supple_branch, parent: :inventory do
    association :user
    item { |inventory|
      Item.find_by_name('しなやかな枝') || FactoryGirl.create(:supple_branch)
    }
    stock 4
    total_cost 960
  end

  factory :my_sharp_fang, parent: :inventory do
    association :user
    item { |inventory|
      Item.find_by_name('するどいキバ') || FactoryGirl.create(:sharp_fang)
    }
    stock 8
    total_cost 960
  end

  factory :my_weight_stone, parent: :inventory do
    association :user
    item { |inventory|
      Item.find_by_name('つけもの石') || FactoryGirl.create(:weight_stone)
    }
    stock 95
    total_cost 8820
  end

  factory :my_rain_and_dew_string, parent: :inventory do
    association :user
    item { |inventory|
      Item.find_by_name('あまつゆのいと') || FactoryGirl.create(:rain_and_dew_string)
    }
    stock 38
    total_cost 38000
  end

end
