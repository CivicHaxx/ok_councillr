class CouncillorsController < ApplicationController

	def index
		@councillors = Councillor.all.order(:last_name).includes(:ward)
	end

	def show	
		@councillor = Councillor.find params[:id]
	end


end
