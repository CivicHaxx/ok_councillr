class CouncillorsController < ApplicationController
	def index
		@councillors = Councillor.all.order(:last_name).includes(:ward)
	end

	def show	
		@councillor          = Councillor.find params[:id]
		@votes               = @councillor.councillor_votes.includes(:motion).page params[:page]
		@rvr_votes           = @councillor.raw_vote_records. page params[:page]
		@total_number_motion = Motion.count
		@absences            = calculated_absence_percent(@councillor)
		@yes_votes           = calculated_yes_percent(@councillor)
		@no_votes            = calculated_no_percent(@councillor)
	end

	private
	def calculated_absence_percent(councillor)
		(councillor.raw_vote_records.where(vote: "Absent").count.to_f / @total_number_motion) * 100
	end

	def calculated_yes_percent(councillor)
		(councillor.raw_vote_records.where(vote: "Yes").count.to_f / @total_number_motion) * 100
	end
	
	def calculated_no_percent(councillor)
		(councillor.raw_vote_records.where(vote: "No").count.to_f / @total_number_motion) * 100
	end
end
