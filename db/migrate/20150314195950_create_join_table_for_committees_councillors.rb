class CreateJoinTableForCommitteesCouncillors < ActiveRecord::Migration
  def change
  	drop_table :committees_councillors
    create_join_table :committees, :councillors do |t|
      # t.index [:committee_id, :councillor_id]
      # t.index [:councillor_id, :committee_id]
    end
  end
end
