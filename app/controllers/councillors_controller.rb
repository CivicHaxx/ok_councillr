class CouncillorsController < ApplicationController

	def index
		@councillors = Councillor.all
	end

	def show	
		@councillor = Councillor.find params[:id]
	end


end
