class AddReferanceRawVoteRecordsCouncillor < ActiveRecord::Migration
  def change
  	add_reference :raw_vote_records, :councillor, index: true
    add_foreign_key :raw_vote_records, :councillors
  end
end
