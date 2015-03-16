class Api::CouncillorsController < ApplicationController
  def index
  	@councillors = Councillor.all

  	render json: @councillors
  end

  def show
  	@councillor = Councillor.find(params[:id])

		render json: @councillor
  end
end
