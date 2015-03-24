class Api::WardsController < ApiController
	def index
  	@wards = if @@query.empty?
  		Ward.all
  	else
			Ward.where("lower(name) LIKE ?", @@query)
		end

  	paginate json: @wards.order(change_query_order), per_page: change_per_page
  end

  def show
  	@ward = Ward.find(params[:id])

  	render json: @ward
  end
end
