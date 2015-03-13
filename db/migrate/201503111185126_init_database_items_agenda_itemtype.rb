class InitDatabaseItemsAgendaItemtype < ActiveRecord::Migration
  def change
    create_table :agendas do |t|
      t.date :date

      t.timestamps null: false
    end

    create_table :item_types do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :items do |t|
      t.string :number
      t.string :title
      t.string :ward
      t.text :sections
      t.text :recommendations
      t.belongs_to :item_type, index: true
      t.belongs_to :agenda, index: true

      t.timestamps null: false
    end
  end

  # add_foreign_key :items, :item_type
  # add_foreign_key :items, :agenda
end
