class Api::MotionsController < ApiController
  def index
  	@motions = if @@query.empty?
  		paginate Motion.all.order(change_query_order), per_page: change_per_page
  	else
			paginate Motion.where("lower(amendment_text) LIKE ?", @@query).order(change_query_order), per_page: change_per_page
		end

  	render json: @motions
  end

  def show
  	@motion = Motion.find(params[:id])

  	render json: @motion, serializer: MotionDetailSerializer
  end
end
