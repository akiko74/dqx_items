# encoding: utf-8


module DqxItems
  module DataLoader

    class ManualWorkLoader

      def self.execute(file_path = ARGV[0], options={})
        if options[:action]
          case options[:action]
          when :add_price
            require 'csv'
            label = true
            label_name = ['item_id', 'item_name', 'item_price']
            _update_count = 0
            _insert_count = 0
            ::CSV.foreach(file_path) do |row|
              if(label)
                label = false
                next
              end
              _item_id    = row[0].nil? ? nil : row[0].strip.to_i
              _item_name  = row[1].strip
              _item_price = row[2].strip.to_i
              raise "Item ID is invalid !" if (!_item_id.nil? && !(_item_id > 0))
              raise "Item Name is invalid !" if _item_name.strip.length == 0
              if item = Item.find_by_name(_item_name)
                raise "Item ID miss match!; #{row} --- #{item}" if item.id != _item_id
                item.price = _item_price
                _update_count += 1
              else
                item = Item.new(:name => _item_name, :price => _item_price)
                _insert_count += 1
              end
              item.save(validate: false)
              p item
            end
            puts "update:#{_update_count}, insert:#{_insert_count}"

          when :add_recipe_kana
            require 'csv'
            label = true
            label_name = ['recipe#name', 'recipe#kana']
            _update_count = 0
            _insert_count = 0
            [{:id=>459, :name=>"ダンサーヘアバンド", :level=>7, :job_id=>5}, {:id=>460, :name=>"初級魔法戦士ベレー", :level=>7, :job_id=>5}, {:id=>461, :name=>"おにのかなぼう", :level=>18, :job_id=>1}, {:id=>462, :name=>"初級魔法戦士服", :level=>9, :job_id=>5}, {:id=>463, :name=>"ダンサーシャツ", :level=>9, :job_id=>5}, {:id=>464, :name=>"ダンサーシューズ", :level=>7, :job_id=>5}, {:id=>465, :name=>"ダンサーパンツ", :level=>8, :job_id=>5}, {:id=>466, :name=>"ダンサーリスト", :level=>8, :job_id=>5}, {:id=>467, :name=>"初級魔法戦士グラブ", :level=>8, :job_id=>5}, {:id=>468, :name=>"初級魔法戦士タイツ", :level=>8, :job_id=>5}, {:id=>469, :name=>"初級魔法戦士のくつ", :level=>7, :job_id=>5}, {:id=>470, :name=>"シルバーサークル", :level=>10, :job_id=>1}, {:id=>471, :name=>"はがねのブーメラン", :level=>14, :job_id=>1}, {:id=>472, :name=>"ニンジャカッター", :level=>17, :job_id=>1}, {:id=>473, :name=>"てつのかなぼう", :level=>8, :job_id=>1}, {:id=>474, :name=>"ウェスタンハット", :level=>14, :job_id=>5}, {:id=>475, :name=>"ウェスタンブラウス", :level=>16, :job_id=>5}, {:id=>476, :name=>"ウェスタンスパッツ", :level=>15, :job_id=>5}, {:id=>477, :name=>"ウェスタングローブ", :level=>15, :job_id=>5}, {:id=>478, :name=>"ウェスタンブーツ", :level=>14, :job_id=>5}, {:id=>479, :name=>"木の葉のぼうし", :level=>14, :job_id=>5}, {:id=>480, :name=>"木の葉のよろい上", :level=>16, :job_id=>5}, {:id=>481, :name=>"木の葉のよろい下", :level=>15, :job_id=>5}, {:id=>482, :name=>"木の葉のうでわ", :level=>15, :job_id=>5}, {:id=>483, :name=>"木の葉のブーツ", :level=>14, :job_id=>5}, {:id=>485, :name=>"ブロンズブーメラン", :level=>3, :job_id=>1}].each do |recipe|
              Recipe.create!(recipe)
            end
            if item = Item.find_by_name('うるわしきのこ2')
              item.destroy
            end
            ::CSV.foreach(file_path) do |row|
              raise "row error; #{row}" unless row.length == 2
              _recipe_name = row[0].strip
              _recipe_kana = row[1].strip
              unless recipe = Recipe.find_by_name(_recipe_name)
                raise "Recipe not found !! #{_recipe_name}"
              end
              if recipe.name == "おしゃれさ+5"
                recipe.level = 10
              end
              recipe.kana = _recipe_kana
              p recipe
              recipe.save!
              p recipe
              _update_count += 1
            end
            puts "update:#{_update_count}, insert:#{_insert_count}"

          when :add_kana
            require 'csv'
            label = true
            label_name = ['item#id', 'item#name', 'item#kana']
            _update_count = 0
            _insert_count = 0
            ::CSV.foreach(file_path) do |row|
              if(label)
                label = false
                next
              end
              _item_id   = row[0].nil? ? nil : row[0].strip.to_i
              _item_name = row[1].strip
              _item_kana = row[2].strip
              raise "Item ID is invalid !" if (!_item_id.nil? && !(_item_id > 0))
              raise "Item Name is invalid !" if _item_name.strip.length == 0
              if item = Item.find_by_name(_item_name)
                raise "Item ID miss match!; #{row} --- #{item}" if item.id != _item_id
                item.kana = _item_kana
                _update_count += 1
              else
                item = Item.new(:name => _item_name, :kana => _item_kana)
                _insert_count += 1
              end
              item.save(validate: false)
              p item
            end
            puts "update:#{_update_count}, insert:#{_insert_count}"

          when :modify
            require 'csv'
            label = true
            label_name = ['recipe','jobLv', 'item','num']
            ::CSV.foreach(file_path) do |row|
              if(label)
                label = false
                next
              end
              next unless row[5]

              result = row[0].match(/^([^\+\d]+(?:(?:\+\d+(?:(?:\.\d+)?%)?)|(?:\d+%\D+))?)(\d+)(\D+)(\d+)$/).to_a
              result.shift
              unless recipe = Recipe.find_by_name(result[0])
                raise StandardError, "#{result[0]} is not found at recipes"
              end
              unless item = Item.find_by_name(result[2])
                raise StandardError, "#{result[2]} is not found at items"
              end
              unless ingredient = Ingredient.find(:first, :conditions => {:recipe_id => recipe.id, :item_id => item.id})
                raise StandardError, "ingredient not found"
              end

              hope = row[5].match(/^([^\+\d]+(?:(?:\+\d+(?:(?:\.\d+)?%)?)|(?:\d+%\D+))?)(\d+)(\D+)(\d+)$/).to_a
              hope.shift
              result.each_with_index do |res,i|
                next if res == hope[i]
                p "#{row[0]} --> #{row[5]}"
                p "#{label_name[i]} Diff: #{res} | #{hope[i]}"
                case i
                when 1
                  recipe.level = hope[i]
                  recipe.save!(validate: false)
                when 2
                  "opps..."
                when 3
                  if(hope[i].to_i > 0)
                    ingredient.number = hope[i]
                    ingredient.save!(validate: false)
                  else
                    ingredient.destroy
                  end
                end

              end
            end

          when :add_recipe_category
            require 'csv'
            label = true
            label_name = ['recipe_name', 'category_name']
            _insert_count = 0
           ::CSV.foreach(file_path) do |row|
             if(label)
               label = false
               next
             end
             _recipe_name = row[0].strip
             _category_name = row[1].strip
             unless recipe = Recipe.find_by_name(_recipe_name)
               raise "Recipe not found ! #{_recipe_name}"
             end
             unless category = Category.find_by_name(_category_name)
               raise "Category not found ! #{_category_name}"
             end
             unless recipe.categories.include?(category)
               cat = recipe.eq_categories.new(:category_id => category.id)
               if cat.save
                _insert_count += 1
               end
             end
           end
           p _insert_count
          else
            raise ArgumentError
          end
        else
        DqxItems::ManualWork::Parser.parse(file_path).each do |recipe_data|
          job = ::Job.find_or_create_by_name(recipe_data.craftsperson.name)
          recipe = ::Recipe.find_or_create_by_name(recipe_data.name, :level => recipe_data.craftsperson.level, :job_id => job.id, :kana => recipe_data.kana)
          recipe_data.materials.each do |material|
            item = ::Item.find_or_create_by_name(material.name)
            if ::Ingredient.where(:recipe_id => recipe.id, :item_id => item.id).empty?
              ::Ingredient.create(:recipe_id => recipe.id, :item_id => item.id, :number => material.num)
            end
          end
        end
        end
      end

    end

  end
end
