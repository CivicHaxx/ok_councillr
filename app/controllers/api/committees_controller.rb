class Api::CommitteesController < ApiController
	def index
		@committees = if @@query.empty?
			Committee.all
		else
			Committee.where("lower(name) LIKE ?", @@query)
		end

		paginate json: @committees.order(change_query_order), per_page: change_per_page
	end

	def show
		@committee = Committee.find(params[:id])

		render json: @committee, serializer: CommitteeDetailSerializer
	end
end
