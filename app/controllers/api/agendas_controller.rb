class Api::AgendasController < ApiController
	def index
		@agendas = if @@query == nil
			Agenda.all.order(@@order)
		else
			Agenda.where("lower(name) LIKE ?", @@query).order(@@order)
		end

		render json: @agendas
	end

	def show
		@agenda = Agenda.find(params[:id])

		render json: @agenda
	end
end
