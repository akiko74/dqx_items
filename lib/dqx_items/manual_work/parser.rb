# encoding: utf-8


require 'nokogiri'


module DqxItems
  module ManualWork

    class Parser

      def self.parse(file_path)
        result = []
        doc = Nokogiri::XML(open(file_path))
        doc.xpath("/recipes/recipe").each do |recipe_elm|
          recipe = Recipe.new
          recipe.name = recipe_elm.xpath("name").text
          recipe.kana = recipe_elm.xpath("kana").text
          recipe.materials = []
          recipe_elm.xpath("materials/material").each do |material_elm|
            material = Material.new
            material.name = material_elm.xpath("name").text
            material.num  = material_elm.xpath("num").text
            recipe.materials << material
          end
          recipe.craftsperson = Craftsperson.new
          recipe.craftsperson.name = recipe_elm.xpath("craftsperson/name").text
          recipe.craftsperson.level = recipe_elm.xpath("craftsperson/level").text
          result << recipe
        end
        result
      end

    end

  end
end

