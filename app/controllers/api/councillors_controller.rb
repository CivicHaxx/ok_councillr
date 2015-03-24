class Api::CouncillorsController < ApiController
  def index
    ward_id = params[:ward_id]
    @councillors = Councillor.all

    @councillors = @councillors.where("lower(first_name) LIKE ? OR 
        lower(last_name) LIKE ? OR 
        lower(email) LIKE ?", @@query, @@query, @@query) unless @@query.empty?
    @councillors = @councillors.where("ward_id = ?", ward_id) if ward_id.present?
		
  	paginate json: @councillors.order(change_query_order), per_page: change_per_page
  end

  def show
  	@councillor = Councillor.find(params[:id])

		render json: @councillor, serializer: CouncillorDetailSerializer
  end
end
