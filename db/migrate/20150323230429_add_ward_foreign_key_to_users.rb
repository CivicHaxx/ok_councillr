class AddWardForeignKeyToUsers < ActiveRecord::Migration
  def change
  	add_reference :users, :ward, index: true
    add_foreign_key :users, :wards
  end
end
