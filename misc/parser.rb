#encoding: utf-8
require 'nokogiri'
require 'open-uri'
require 'builder'


puts 'enter job name from "武器", "防具", "道具", "木工", "裁縫", "ツボ", "ランプ"'
job_name = gets.chomp
puts 'enter url'
url = gets

doc = Nokogiri::HTML(open(url))
recipes = doc.xpath('//table/tr/td').inject([]){|i, td| i << td.text.gsub("\t","")}
n = 6
recipes_array = []
  while n < recipes.count
    recipes_array << {:name => recipes[n], :level => recipes[n+1], :ingredients => recipes[n+2]}
    n +=5
  end

recipes_array.keep_if do |array|
  if Recipe.find_by_name(array[:name]).nil?
    array[:ingredients] = array[:ingredients].split("、").inject([]){|i, item| i << {:item => item.gsub(/×[\d]+/) {$1}, :num => item.gsub(/^[\D]+/) {$1}}}
    puts "enter Kana for #{array[:name]}"
    kana = gets.chomp
    array[:kana] = kana
  end
end

file = File.new("#{Rails.root}/misc/new_recipes.xml", "wb")
xml = Builder::XmlMarkup.new(:indent => 2, :target => file)
xml.instruct!
xml.recipes {
  recipes_array.each do |array|
    xml.recipe {
      xml.name(array[:name])
      xml.kana(array[:kana])
      xml.craftsperson {
        xml.name(job_name)
        xml.level(array[:level])
      }
      xml.materials {
        array[:ingredients].each do |ingredient|
          xml.material {
            xml.name(ingredient[:item])
            xml.num(ingredient[:num])
          }
        end
      }
      }
  end
}
file.close
