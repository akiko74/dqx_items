# encoding: utf-8


module DqxItems
  module DataLoader

    class ManualWorkLoader

      def self.execute(file_path = ARGV[0])
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
