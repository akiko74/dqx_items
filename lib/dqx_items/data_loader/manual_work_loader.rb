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
              item.save
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
                  recipe.save!
                when 2
                  "opps..."
                when 3
                  if(hope[i].to_i > 0)
                    ingredient.number = hope[i]
                    ingredient.save!
                  else
                    ingredient.destroy
                  end
                end

              end
            end

          else
            raise ArgumentError
          end
        else
        DqxItems::ManualWork::Parser.parse(file_path).each do |recipe_data|
          job = ::Job.find_or_create_by_name(recipe_data.craftsperson.name)
          recipe = ::Recipe.find_or_create_by_name(recipe_data.name, :level => recipe_data.craftsperson.level, :job_id => job.id)
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
