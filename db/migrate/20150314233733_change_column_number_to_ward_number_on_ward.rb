class ChangeColumnNumberToWardNumberOnWard < ActiveRecord::Migration
  def change
  	change_table :wards do |t|
  		t.rename :number, :ward_number
  	end
  end
end
