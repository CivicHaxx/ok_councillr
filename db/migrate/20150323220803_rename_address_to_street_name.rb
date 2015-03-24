class RenameAddressToStreetName < ActiveRecord::Migration
	change_table :users do |t|
		t.rename :address, :street_name
	end
end
