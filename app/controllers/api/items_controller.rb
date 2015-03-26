class Api::ItemsController < ApiController
  def index
    item_type_id = params[:item_type_id]
    councillor_id = params[:councillor_id]
    agenda_id = params[:agenda_id]
    
    @items = Item.all

    @items = @items.where("lower(title) LIKE ? OR lower(origin_type) = ?", @@query, @@query.gsub("%", "")) unless @@query.empty?
    @items = @items.where("item_type_id = ?", item_type_id) if item_type_id.present?
    @items = @items.where("origin_id = ? AND origin_type = 'Councillor'", councillor_id) if councillor_id.present?
    @items = @items.where("origin_id = ? AND origin_type = 'Agenda'", agenda_id) if agenda_id.present?

		paginate json: @items.order(change_query_order), per_page: change_per_page
  end

  def show
  	@item = Item.find(params[:id])

		render json: @item
  end
end
