class Api::WardsController < ApiController
	def index
  	@wards = if @@query.empty?
  		paginate Ward.all.order(change_query_order), per_page: change_per_page
  	else
			paginate Ward.where("lower(name) LIKE ?", @@query).order(change_query_order), per_page: change_per_page
		end

  	render json: @wards
  end

  def show
  	@ward = Ward.find(params[:id])

  	render json: @ward
  end
end
