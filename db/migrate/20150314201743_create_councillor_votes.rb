class CreateCouncillorVotes < ActiveRecord::Migration
  def change
    create_table :councillor_votes do |t|
      t.string :vote
      t.belongs_to :motion, index: true
      t.belongs_to :councillor, index: true

      t.timestamps null: false
    end
    add_foreign_key :councillor_votes, :motions
    add_foreign_key :councillor_votes, :councillors
  end
end
