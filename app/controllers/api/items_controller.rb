class Api::ItemsController < ApiController
  def index
  	@items = if @@query == nil
  		Item.all.order(@@order)
  	else
			Item.where("lower(name) LIKE ?", @@query).order(@@order)
		end

		render json: @items
  end

  def show
  	@item = Item.find(params[:id])

		render json: @item
  end
end
