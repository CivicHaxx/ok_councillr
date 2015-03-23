class Api::ItemsController < ApiController
  def index
  	@items = if @@query.empty?
  		paginate Item.all.order(@@order), per_page: change_per_page
  	else
			paginate Item.where("lower(name) LIKE ?", @@query).order(@@order), per_page: change_per_page
		end

		render json: @items
  end

  def show
  	@item = Item.find(params[:id])

		render json: @item
  end
end
