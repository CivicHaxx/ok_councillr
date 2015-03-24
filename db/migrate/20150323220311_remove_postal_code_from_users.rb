class RemovePostalCodeFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :postal_code, :string
  end
end
