class Api::MotionsController < ApiController
  def index
  	@motions = if @@query.empty?
  		Motion.all
  	else
      Motion.where("lower(amendment_text) LIKE ?", @@query)
		end

  	paginate json: @motions.order(change_query_order), per_page: change_per_page
  end

  def show
  	@motion = Motion.find(params[:id])

  	render json: @motion, serializer: MotionDetailSerializer
  end
end
