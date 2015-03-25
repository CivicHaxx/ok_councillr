class CouncillorsController < ApplicationController
	def index
		@councillors = Councillor.all.order(:last_name).includes(:ward)
	end

	def show	
		@councillor = Councillor.find params[:id]
		@votes = @councillor.councillor_votes.includes(:motion)
		@rvr_votes = @councillor.raw_vote_records
	end
end
