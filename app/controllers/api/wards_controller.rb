class Api::WardsController < ApiController
	def index
  	@wards = if @@query.empty?
  		Ward.all.order(@@order)
  	else
			Ward.where("lower(name) LIKE ?", @@query).order(@@order)
		end

  	render json: @wards
  end

  def show
  	@ward = Ward.find(params[:id])

  	render json: @ward
  end
end
