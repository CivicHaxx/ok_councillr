class Api::AgendasController < ApiController
	def index
		@agendas = if @@query.empty?
			paginate Agenda.all.order(change_query_order), per_page: change_per_page
		else
			paginate Agenda.where("lower(name) LIKE ?", @@query).order(change_query_order), per_page: change_per_page
		end

		render json: @agendas
	end

	def show
		@agenda = Agenda.find(params[:id])

		render json: @agenda
	end
end
