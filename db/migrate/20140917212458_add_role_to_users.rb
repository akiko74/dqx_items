class AddRoleToUsers < ActiveRecord::Migration

  def up
    User.transaction do
      add_column :users, :role, :integer, default: 1, null: false
      User.all.each { |u| u.update_attributes(role: :admin) }
    end
  end

  def down
    remove_column :users, :role
  end

end
