class Api::CommitteesController < ApiController
	def index
		name = params[:name]
		councillor_id = params[:councillor_id]
		@committees = Committee.all

		@committees = @committees.where("lower(name) LIKE ?", @@query) unless @@query.empty?
		@committees = @committees.where("lower(name) = ?", name.downcase) if name.present?
		@committees = @committees.joins(:committees_councillors).where("councillor_id = ?", councillor_id) if councillor_id.present?

		paginate json: @committees.order(change_query_order), per_page: change_per_page
	end

	def show
		@committee = Committee.find(params[:id])

		render json: @committee, serializer: CommitteeDetailSerializer
	end
end
