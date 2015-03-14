class CreateCommittees < ActiveRecord::Migration
  def change
    create_table :committees do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
