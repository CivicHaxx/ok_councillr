class DropColumnWardForCouncillorsItems < ActiveRecord::Migration
  def change
  	remove_column :councillors, :ward
  	remove_column :items, :ward
  end
end
