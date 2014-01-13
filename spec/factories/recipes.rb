FactoryGirl.define do

  factory :nusutto_ware_recipe, parent: :recipe do
    name 'ぬすっとの服'
    level 5
    usage_count 1
    kana 'ぬすっとのふく'
    association :job, factory: :saihou
    after(:create) { |recipe|
      FactoryGirl.create(
        :ingredient,
          recipe: recipe,
          item: (Item.find_by_name('小さなこうら') || FactoryGirl.create(:small_shell)),
          number: 1
      )
      FactoryGirl.create(
        :ingredient,
          recipe: recipe,
          item: (Item.find_by_name('ようせいの粉') || FactoryGirl.create(:fairy_powder)),
          number: 1
      )
    }
  end

  factory :beginners_magic_knight_ware, parent: :recipe do
    name '初級魔法戦士服'
    level 9
    usage_count 1
    kana 'しょきゅうまほうせんしふく'
    association :job, factory: :saihou
    after(:create) { |recipe|
      FactoryGirl.create(
        :ingredient,
          recipe: recipe,
          item: (Item.find_by_name('あやかしそう') || FactoryGirl.create(:ayakashi_sou)),
          number: 3
      )
      FactoryGirl.create(
        :ingredient,
          recipe: recipe,
          item: (Item.find_by_name('コットン草') || FactoryGirl.create(:cotton_sou)),
          number: 3
      )
    }
  end

  factory :partizan, parent: :recipe do
    name 'パルチザン'
    level 17
    usage_count 1
    kana 'パルチザン'
    association :job, factory: :weapon_blacksmith
    after(:create) { |recipe|
      FactoryGirl.create(
        :ingredient,
          recipe: recipe,
          item: (Item.find_by_name('ぎんのこうせき') || FactoryGirl.create(:silver_stone)),
          number: 6
      )
      FactoryGirl.create(
        :ingredient,
          recipe: recipe,
          item: (Item.find_by_name('しなやかな枝') || FactoryGirl.create(:supple_branch)),
          number: 3
      )
      FactoryGirl.create(
        :ingredient,
          recipe: recipe,
          item: (Item.find_by_name('するどいキバ') || FactoryGirl.create(:sharp_fang)),
          number: 3
      )
    }
  end

  factory :copper_sword, parent: :recipe do
    name 'どうのつるぎ'
    level 1
    usage_count 1
    kana 'どうのつるぎ'
    association :job, factory: :weapon_blacksmith
    after(:create) { |recipe|
      FactoryGirl.create(
        :ingredient,
          recipe: recipe,
          item: (Item.find_by_name('どうのこうせき') || FactoryGirl.create(:copper_stone)),
          number: 3
      )
    }
  end

end
