class Api::AgendasController < ApiController
	def index
		committee_id = params[:committee_id]
		@agendas = Agenda.all

		@agendas = Agenda.where("date = ?", Date.strptime(@@query.gsub("%",""), '%m-%d-%Y')) unless @@query.empty?
		@agendas = Agenda.where("committee_id = ?", committee_id) if committee_id.present?

		paginate json: @agendas.order(change_query_order), per_page: change_per_page
	end

	def show
		@agenda = Agenda.find(params[:id])

		render json: @agenda
	end
end
