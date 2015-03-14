class CreateTableForCommitteesCouncillors < ActiveRecord::Migration
  def change
    create_table :committees_councillors do |t|
      t.belongs_to :committee, index: true
      t.belongs_to :councillor, index: true
    end
    add_foreign_key :committees_councillors, :committees
    add_foreign_key :committees_councillors, :councillors
  end
end
