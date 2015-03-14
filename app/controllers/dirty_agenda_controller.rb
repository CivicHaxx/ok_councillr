class DirtyAgendaController < ApplicationController

def index
	@agendas = DirtyAgenda.all
end

def show
	@agenda = DirtyAgenda.find(params[:id])
end

end
