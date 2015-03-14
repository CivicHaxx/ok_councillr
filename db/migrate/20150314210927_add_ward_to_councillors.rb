class AddWardToCouncillors < ActiveRecord::Migration
  def change
    add_reference :councillors, :ward, index: true
    add_foreign_key :councillors, :wards
  end
end
