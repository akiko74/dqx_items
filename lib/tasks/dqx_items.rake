# encoding: utf-8

require File.expand_path("../../../config/environment", __FILE__)
require 'dqx_items'

namespace :dqx_items do

  desc "Load Recipes form misc/recipes.xml"
  task :load_recipes do
    DqxItems::DataLoader::ManualWorkLoader.execute("#{Rails.root}/misc/recipes.xml")
  end

end

