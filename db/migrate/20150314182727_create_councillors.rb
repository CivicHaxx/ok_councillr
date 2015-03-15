class CreateCouncillors < ActiveRecord::Migration
  def change
    create_table :councillors do |t|
      t.string :first_name
      t.string :last_name
      t.integer :ward
      t.date :start_date_in_office
      t.string :website
      t.string :twitter_handle
      t.string :facebook_handle
      t.string :email
      t.string :phone_number
      t.string :address
      t.string :image

      t.timestamps null: false
    end
  end
end
