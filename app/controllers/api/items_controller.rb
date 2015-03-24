class Api::ItemsController < ApiController
  def index
    item_type_id = params[:item_type_id]
    @items = Item.all

    @items = @items.where("item_type_id = ?", item_type_id) if item_type_id.present?
    @items = Item.where("lower(title) LIKE ? OR lower(origin_type) = ?", @@query, @@query.gsub("%", "")) unless @@query.empty?

		paginate json: @items.order(change_query_order), per_page: change_per_page
  end

  def show
  	@item = Item.find(params[:id])

		render json: @item
  end
end
