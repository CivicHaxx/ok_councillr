class CreateMotions < ActiveRecord::Migration
  def change
    create_table :motions do |t|
      t.string :amendment_text
      t.belongs_to :councillor, index: true
      t.belongs_to :item, index: true
      t.belongs_to :motion_type, index: true

      t.timestamps null: false
    end
    add_foreign_key :motions, :councillors
    add_foreign_key :motions, :items
    add_foreign_key :motions, :motion_types
  end
end
