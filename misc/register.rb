# encoding: utf-8

require 'nokogiri'
require 'aws-sdk'

puts "enter filename (replace .html to .xml)"
file = gets.chomp

obj = AWS::S3.new(region: 'ap-northeast-1').buckets['dqxdata/uploads'].objects[file]
tempfile = Tempfile.new(file)
File.open(tempfile, 'wb') do |line|
  obj.read do |chunk|
  line.write(chunk)
  end
end

doc = Nokogiri::XML(open(tempfile))
job_id = Job.find_by_name(doc.xpath('//recipes/recipe/craftsperson').first.xpath("name").text).id
doc.xpath('//recipes/recipe').each do |recipe_elm|
  recipe = Recipe.new
  recipe.name = recipe_elm.xpath("name").text
  recipe.kana = recipe_elm.xpath("kana").text
  recipe.level = recipe_elm.xpath("craftsperson/level").text.to_i
  recipe.job_id = job_id
    recipe_elm.xpath("materials/material").each do |mat|
      unless Item.find_by_name(mat.xpath("name").text).present?
        item = Item.new(:name => mat.xpath("name").text)
        puts "アイテム#{mat.xpath("name").text}を登録します。"
        puts "かなを入れてください"
        item.kana = gets.chomp
        puts "価格を入れてください。(バザーのみの場合は0)"
        item.price = gets.chomp
        puts "この内容で登録します。アイテム名#{mat.xpath("name").text},かな#{item.kana},価格#{item.price}  Y/N"
        next if gets.chomp == "N"
        item.save
      end
    ingredient = recipe.ingredients.build(:item_id => Item.find_by_name(mat.xpath("name").text).id, :number => mat.xpath("num").text.to_i)
    end
  recipe.save
end

