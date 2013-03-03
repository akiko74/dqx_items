class CreateTools < ActiveRecord::Migration
  def change
    create_table :tools do |t|
      t.integer :job_id
      t.string  :name
      t.integer :usage_count
      t.timestamps
    end
  end
end
