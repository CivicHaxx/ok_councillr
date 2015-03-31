class Api::AgendasController < ApiController
	def index
		committee_id = params[:committee_id]
		@agendas = Agenda.all

		@agendas = search_by_date_range(@@query.gsub("%",""), @agendas, "date") unless @@query.empty?
		@agendas = @agendas.where("committee_id = ?", committee_id) if committee_id.present?
    @agendas = search_by_date_range(params[:date], @agendas, "date")

		paginate json: @agendas.order(change_query_order), per_page: change_per_page
	end

	def show
		@agenda = Agenda.find(params[:id])

		render json: @agenda
	end
end
