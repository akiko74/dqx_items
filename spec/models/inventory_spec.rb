# encoding: utf-8

require 'spec_helper'

describe "素材を登録する場合" do
  before do
    @inventory = Inventory.new(:user_id => 1, :item_id => 1, :stock => 1, :average_cost => 100)
  end

  it "新たなデータが作成できること" do
    @inventory.save.should be_true
  end

  it "DBにデータが1件増えること" do
    Proc.new { @inventory.save }.should change(Inventory, :count).by(1)
  end


end

