# encoding: utf-8

require File.expand_path("../../../config/environment", __FILE__)
require 'dqx_items'

namespace :dqx_items do

  desc "Load Recipes form misc/recipes.xml"
  task :load_recipes do
    DqxItems::DataLoader::ManualWorkLoader.execute("#{Rails.root}/misc/recipes.xml")
  end

  desc "Modify Recipes from misc/modify_recipes.csv"
  task :modify_recipes do
    DqxItems::DataLoader::ManualWorkLoader.execute("#{Rails.root}/misc/modify_recipes.csv", :action => :modify)
  end

  desc "Load Recipes form misc/recipes2.xml"
  task :load_recipes2 do
    DqxItems::DataLoader::ManualWorkLoader.execute("#{Rails.root}/misc/recipes2.xml")
  end

  desc "Load Recipes form misc/recipes3.xml"
  task :load_recipes3 do
    DqxItems::DataLoader::ManualWorkLoader.execute("#{Rails.root}/misc/recipes3.xml")
  end

  desc "Load item prices from misc/item_prices.csv"
  task :add_item_pricess do
    DqxItems::DataLoader::ManualWorkLoader.execute("#{Rails.root}/misc/item_prices.csv", :action => :add_price)
  end

  desc "Load item kana from misc/item_kana.csv"
  task :add_item_kana do
    DqxItems::DataLoader::ManualWorkLoader.execute("#{Rails.root}/misc/item_kana.csv", :action => :add_kana)
  end


  desc "Load all recipes"
  task :load_all_recipes do
    %w(load_recipes modify_recipes load_recipes2 load_recipes3 add_item_kana add_item_pricess).each do |recipe|
	    p recipe
      #Rake::Task["dqx_items:#{recipe}"].invoke
    end
  end


  desc "Load Demo Data"
  task :load_demo_data do
    require 'factory_girl'
    #Dir::glob("factories/*.rb") do |file|
    #  load File.expand_path(file)
    #end
    User.delete_all(:email => "testuser@localhost.localdomain")

    _user = FactoryGirl.create(:user, :email => "testuser@localhost.localdomain")
    FactoryGirl.create(:inventory, user: _user, item_id: 1)
    FactoryGirl.create(:inventory, user: _user, item_id: 2)
    FactoryGirl.create(:inventory, user: _user, item_id: 3)
  end

end

