class CreateUserVotes < ActiveRecord::Migration
  def change
    create_table :user_votes do |t|
    	t.string :vote, 			 	:null => false
    	t.belongs_to :user, index: true 
    	t.belongs_to :item, index: true 

      t.timestamps null: false
    end
  end
end
