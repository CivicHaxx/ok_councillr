class Api::MotionsController < ApiController
  def index
    amendment_text = params[:amendment_text]
    councillor_id = params[:councillor_id]
    item_id = params[:item_id]
    motion_type_id = params[:motion_type_id]
  	@motions = Motion.all 

    @motions = @motions.where("lower(amendment_text) LIKE ?", @@query) unless @@query.empty?
    @motions = @motions.where("lower(amendment_text) LIKE ?", "%#{amendment_text.downcase}%") if amendment_text.present?
    @motions = @motions.where("councillor_id = ?", councillor_id) if councillor_id.present?
    @motions = @motions.where("item_id = ?", item_id) if item_id.present?
    @motions = @motions.where("motion_type_id = ?", motion_type_id) if motion_type_id.present?

  	paginate json: @motions.order(change_query_order), per_page: change_per_page
  end

  def show
  	@motion = Motion.find(params[:id])

  	render json: @motion, serializer: MotionDetailSerializer
  end
end
