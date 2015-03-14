class CreateTableMotionTypes < ActiveRecord::Migration
  def change
    create_table :motion_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
