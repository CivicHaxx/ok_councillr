class Api::ItemsController < ApiController
  def index
  	@items = if @@query.empty?
      Item.all.order(change_query_order)
  	else
			Item.where("lower(title) LIKE ? OR 
        lower(origin_type) = ?", @@query, @@query.gsub("%", "")).order(change_query_order)
		end

		paginate json: @items, per_page: change_per_page
  end

  def show
  	@item = Item.find(params[:id])

		render json: @item
  end
end
