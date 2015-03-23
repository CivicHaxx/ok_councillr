class Api::MotionsController < ApiController
  def index
  	@motions = if @@query.empty?
  		Motion.all.order(@@order)
  	else
			Motion.where("lower(name) LIKE ?", @@query).order(@@order)
		end

  	render json: @motions
  end

  def show
  	@motion = Motion.find(params[:id])

  	render json: @motion, serializer: MotionDetailSerializer
  end
end
