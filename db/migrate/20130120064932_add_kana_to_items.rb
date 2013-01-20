class AddKanaToItems < ActiveRecord::Migration
  def change
    add_column :items, :kana, :string
  end
end
