class Api::AgendasController < ApiController
	def index
		committee_id = params[:committee_id]

		@agendas = if @@query.empty? && committee_id == nil
			Agenda.all.order(change_query_order)
		elsif @@query.empty? == false
			Agenda.where("date = ?", Date.strptime(@@query.gsub("%",""), '%m-%d-%Y')).order(change_query_order)
		else
			Agenda.where("committee_id = ?", committee_id).order(change_query_order)
		end

		paginate json: @agendas, per_page: change_per_page
	end

	def show
		@agenda = Agenda.find(params[:id])

		render json: @agenda
	end
end
