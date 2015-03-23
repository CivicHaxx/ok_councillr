class Api::MotionsController < ApiController
  def index
  	@motions = Motion.all.order(@@order)

  	render json: @motions
  end

  def show
  	@motion = Motion.find(params[:id])

  	render json: @motion, serializer: MotionDetailSerializer
  end
end
