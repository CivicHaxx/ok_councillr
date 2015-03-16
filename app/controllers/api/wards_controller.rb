class Api::WardsController < ApplicationController
	def index
  	@wards = Ward.all

  	render json: @wards
  end

  def show
  	@ward = Ward.find(params[:id])

  	render json: @ward
  end
end
