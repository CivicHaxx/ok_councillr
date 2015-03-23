class Api::AgendasController < ApiController
	def index
		committee_id = params[:committee_id]

		@agendas = if @@query.empty? && committee_id == nil
			paginate Agenda.all.order(change_query_order), per_page: change_per_page
		elsif @@query.empty? == false
			paginate Agenda.where("date = ?", Date.strptime(@@query.gsub("%",""), '%m-%d-%Y')).order(change_query_order), per_page: change_per_page
		else
			paginate Agenda.where("committee_id = ?", committee_id).order(change_query_order), per_page: change_per_page
		end

		render json: @agendas
	end

	def show
		@agenda = Agenda.find(params[:id])

		render json: @agenda
	end
end
