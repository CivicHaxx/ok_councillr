class Api::CommitteesController < ApiController
	def index
		@committees = if @@query.empty?
			paginate Committee.all.order(@@order), per_page: change_per_page
		else
			paginate Committee.where("lower(name) LIKE ?", @@query).order(@@order), per_page: change_per_page
		end

		render json: @committees
	end

	def show
		@committee = Committee.find(params[:id])

		render json: @committee, serializer: CommitteeDetailSerializer
	end
end
