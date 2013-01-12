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
end

