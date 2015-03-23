class Api::CommitteesController < ApiController
	def index
		@committees = Committee.all

		render json: @committees
	end

	def show
		@committee = Committee.find(params[:id])

		render json: @committee, serializer: CommitteeDetailSerializer
	end
end
