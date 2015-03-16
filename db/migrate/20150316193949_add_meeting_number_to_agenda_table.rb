class AddMeetingNumberToAgendaTable < ActiveRecord::Migration
  def change
  	add_column :agendas, :meeting_num, :integer
  end
end
