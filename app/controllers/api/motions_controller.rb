class Api::MotionsController < ApplicationController
  def index
  	@motions = Motion.all

  	render json: @motions
  end

  def show
  	@motion = Motion.find(params[:id])

  	render json: @motion, serializer: MotionDetailSerializer
  end
end
