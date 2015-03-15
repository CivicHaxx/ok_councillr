class AddColumnCommitteeForeignKeyToAgendas < ActiveRecord::Migration
  def change
    add_reference :agendas, :committee, index: true
    add_foreign_key :agendas, :committees
  end
end
