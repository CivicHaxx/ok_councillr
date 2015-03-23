class Api::WardsController < ApiController
	def index
  	@wards = Ward.all.order(@@order)

  	render json: @wards
  end

  def show
  	@ward = Ward.find(params[:id])

  	render json: @ward
  end
end
