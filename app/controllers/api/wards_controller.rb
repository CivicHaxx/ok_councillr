class Api::WardsController < ApiController
	def index
    name = params[:name]
  	@wards = Ward.all

    @wards = @wards.where("lower(name) LIKE ?", @@query) unless @@query.empty?
    @wards = @wards.where("lower(name) LIKE ?", "%#{name.downcase}%") if name.present?

  	paginate json: @wards.order(change_query_order), per_page: change_per_page
  end

  def show
  	@ward = Ward.find(params[:id])

  	render json: @ward
  end
end
