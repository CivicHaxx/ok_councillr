class RemoveColumnAgendaFromItems < ActiveRecord::Migration
  def change
    remove_reference :items, :agenda, index: true
  end
end
