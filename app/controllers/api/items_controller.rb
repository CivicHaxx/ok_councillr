class Api::ItemsController < ApiController
  def index
  	@items = if @@query.empty?
  		paginate Item.all.order(change_query_order), per_page: change_per_page
  	else
			paginate Item.where("lower(title) LIKE ? OR 
        lower(origin_type) = ?", @@query, @@query.gsub("%", "")).order(change_query_order), per_page: change_per_page
		end

		render json: @items
  end

  def show
  	@item = Item.find(params[:id])

		render json: @item
  end
end
