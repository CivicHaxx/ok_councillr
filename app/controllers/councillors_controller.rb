class CouncillorsController < ApplicationController
	def index
		@councillors = Councillor.all.order(:last_name).includes(:ward)
	end

	def show	
		@councillor = Councillor.find params[:id]
		@votes = @councillor.councillor_votes.includes(:motion)
		@rvr_votes = @councillor.raw_vote_records
		@absences = calculated_absence_percent(@councillor)
	end

	private
	def calculated_absence_percent(councillor)
		total_number_motion = Motion.count

		(councillor.councillor_votes.where(vote: "Skip").count.to_f / total_number_motion) * 100
	end
end
