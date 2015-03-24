class Api::ItemsController < ApiController
  def index
    item_type_id = params[:item_type_id]
    @items = Item.all.order(change_query_order)

    @items = @items.where("item_type_id = ?", item_type_id).order(change_query_order) if item_type_id.present?
    @items = Item.where("lower(title) LIKE ? OR lower(origin_type) = ?", @@query, @@query.gsub("%", "")).order(change_query_order) unless @@query.empty?

		paginate json: @items, per_page: change_per_page
  end

  def show
  	@item = Item.find(params[:id])

		render json: @item
  end
end
