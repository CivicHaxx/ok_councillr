class Api::CouncillorsController < ApiController
  def index
  	@councillors = if @@query.empty?
  		Councillor.all.order(change_query_order)
  	else
			Councillor.where("lower(first_name) LIKE ? OR 
        lower(last_name) LIKE ? OR 
        lower(email) LIKE ?", @@query, @@query, @@query).order(change_query_order)
		end

  	paginate json: @councillors, per_page: change_per_page
  end

  def show
  	@councillor = Councillor.find(params[:id])

		render json: @councillor, serializer: CouncillorDetailSerializer
  end
end
