class CouncillorsController < ApplicationController
	def index
		@councillors = Councillor.all.order(:last_name).includes(:ward)
	end

	def show	
		@councillor          = Councillor.find params[:id]
		@votes               = @councillor.councillor_votes.includes(:motion).page params[:page]
		@rvr_votes           = @councillor.raw_vote_records. page params[:page]
		@absences            = calculated_percent_for("Absent", @councillor)
		@yes_votes           = calculated_percent_for("Yes", @councillor)
		@no_votes            = calculated_percent_for("No", @councillor)
	end

	private
	def calculated_percent_for(vote, councillor)
		total_number_motion = Motion.count

		(councillor.raw_vote_records.where(vote: vote).count.to_f / total_number_motion) * 100
	end
end
