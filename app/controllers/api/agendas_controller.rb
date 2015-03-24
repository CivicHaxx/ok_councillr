class Api::AgendasController < ApiController
	def index
		committee_id = params[:committee_id]

		@agendas = if @@query.empty? && committee_id == nil
			Agenda.all
		elsif @@query.empty? == false
			Agenda.where("date = ?", Date.strptime(@@query.gsub("%",""), '%m-%d-%Y'))
		else
			Agenda.where("committee_id = ?", committee_id)
		end

		paginate json: @agendas.order(change_query_order), per_page: change_per_page
	end

	def show
		@agenda = Agenda.find(params[:id])

		render json: @agenda
	end
end
