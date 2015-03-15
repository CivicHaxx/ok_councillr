class CreateJoinTableWardItem < ActiveRecord::Migration
  def change
    create_join_table :wards, :items do |t|
      # t.index [:ward_id, :item_id]
      # t.index [:item_id, :ward_id]
    end
  end
end
