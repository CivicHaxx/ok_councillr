class Api::CouncillorsController < ApiController
  def index
  	@councillors = if @@query.empty?
  		paginate Councillor.all.order(change_query_order), per_page: change_per_page
  	else
			paginate Councillor.where("lower(name) LIKE ?", @@query).order(change_query_order), per_page: change_per_page
		end

  	render json: @councillors
  end

  def show
  	@councillor = Councillor.find(params[:id])

		render json: @councillor, serializer: CouncillorDetailSerializer
  end
end
