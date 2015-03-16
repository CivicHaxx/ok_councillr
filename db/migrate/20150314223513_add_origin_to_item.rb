class AddOriginToItem < ActiveRecord::Migration
  def change
    add_reference :items, :origin, polymorphic: true, index: true
  end
end
