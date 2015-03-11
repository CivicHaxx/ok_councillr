class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :ward
      t.string :number
      t.text :raw_html
      t.belongs_to :item_type, index: true

      t.timestamps null: false
    end

    create_table :item_types do |t|
      t.string :type

      t.timestamps null: false
    end

    create_table :agendas do |t|
      t.date :date

      t.timestamps null: false
    end
  end

  add_foreign_key :items, :item_types
end
