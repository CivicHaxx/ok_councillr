class Api::AgendasController < ApiController
	def index
		@agendas = Agenda.all.order(@@order)

		render json: @agendas
	end

	def show
		@agenda = Agenda.find(params[:id])

		render json: @agenda
	end
end
