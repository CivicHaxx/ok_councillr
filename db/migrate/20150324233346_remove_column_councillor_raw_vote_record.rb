class RemoveColumnCouncillorRawVoteRecord < ActiveRecord::Migration
  def change
  	remove_column :raw_vote_records, :councillor_id
    remove_column :raw_vote_records, :councillor_name
  end
end
