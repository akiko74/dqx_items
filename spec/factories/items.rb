FactoryGirl.define do

  factory :small_shell, parent: :item do
    name '小さなこうら'
    price 250
    kana 'ちいさなこうら'
  end

  factory :fairy_powder, parent: :item do
    name 'ようせいの粉'
    price 100
    kana 'ようせいのこな'
  end

  factory :ayakashi_sou, parent: :item do
    name 'あやかしそう'
    price 290
    kana 'あやかしそう'
  end

  factory :cotton_sou, parent: :item do
    name 'コットン草'
    price 120
    kana 'こっとんそう'
  end

  factory :silver_stone, parent: :item do
    name 'ぎんのこうせき'
    price 240
    kana 'ぎんのこうせき'
  end

  factory :supple_branch, parent: :item do
    name 'しなやかな枝'
    price 240
    kana 'しなやかなえだ'
  end

  factory :sharp_fang, parent: :item do
    name 'するどいキバ'
    price 120
    kana 'するどいきば'
  end

  factory :weight_stone, parent: :item do
    name 'つけもの石'
    price 110
    kana 'つけものいし'
  end

  factory :rain_and_dew_string, parent: :item do
    name 'あまつゆのいと'
    price 1000
    kana 'あまつゆのいと'
  end

  factory :copper_stone, parent: :item do
    name 'どうのこうせき'
    price 60
    kana 'どうのこうせき'
  end

end
