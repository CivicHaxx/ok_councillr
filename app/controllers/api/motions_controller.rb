class Api::MotionsController < ApiController
  def index
  	@motions = if @@query.empty?
  		Motion.all.order(change_query_order)
  	else
      Motion.where("lower(amendment_text) LIKE ?", @@query).order(change_query_order)
		end

  	paginate json: @motions, per_page: change_per_page
  end

  def show
  	@motion = Motion.find(params[:id])

  	render json: @motion, serializer: MotionDetailSerializer
  end
end
