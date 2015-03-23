class Api::CouncillorsController < ApiController
  def index
  	@councillors = if @@query == nil
  		Councillor.all.order(@@order)
  	else
			Councillor.where("lower(name) LIKE ?", @@query).order(@@order)
		end

  	render json: @councillors
  end

  def show
  	@councillor = Councillor.find(params[:id])

		render json: @councillor, serializer: CouncillorDetailSerializer
  end
end
