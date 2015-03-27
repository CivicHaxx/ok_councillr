class AddSynopsisColumnToItem < ActiveRecord::Migration
  def change
    add_column :items, :synopsis, :text
  end
end
