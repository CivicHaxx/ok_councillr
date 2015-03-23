class Api::CommitteesController < ApiController
	def index
		@committees = if @@query == nil
			Committee.all.order(@@order)
		else
			Committee.where("lower(name) LIKE ?", @@query).order(@@order)
		end

		render json: @committees
	end

	def show
		@committee = Committee.find(params[:id])

		render json: @committee, serializer: CommitteeDetailSerializer
	end
end
