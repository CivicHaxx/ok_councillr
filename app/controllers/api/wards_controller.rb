class Api::WardsController < ApiController
	def index
  	@wards = if @@query.empty?
  		Ward.all.order(change_query_order)
  	else
			Ward.where("lower(name) LIKE ?", @@query).order(change_query_order)
		end

  	paginate json: @wards, per_page: change_per_page
  end

  def show
  	@ward = Ward.find(params[:id])

  	render json: @ward
  end
end
