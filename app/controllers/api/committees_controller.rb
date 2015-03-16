class Api::CommitteesController < ApplicationController
	def index
		@committees = Committee.all

		render json: @committees
	end

	def show
		@committee = Committee.find(params[:id])

		render json: @committee
	end
end
