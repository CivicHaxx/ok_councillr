class Api::CommitteesController < ApiController
	def index
		@committees = if @@query.empty?
			Committee.all.order(change_query_order)
		else
			Committee.where("lower(name) LIKE ?", @@query).order(change_query_order)
		end

		paginate json: @committees, per_page: change_per_page
	end

	def show
		@committee = Committee.find(params[:id])

		render json: @committee, serializer: CommitteeDetailSerializer
	end
end
