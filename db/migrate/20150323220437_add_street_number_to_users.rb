class AddStreetNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :street_num, :integer
  end
end
