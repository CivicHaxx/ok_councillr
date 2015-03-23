class AddWardForeignKeyToUsers < ActiveRecord::Migration
  def change
  	add_foreign_key :users, :ward_id
  end
end
