class ItemsController < ApplicationController
	helper_method :display_user_votes_for, :new_item_for_current_user

	def index
		action_id = ItemType.find_by_name("Action").id
		@items = Item.where(item_type_id: action_id).includes(:user_votes)

		@items = if params[:search] == nil
			@items.page params[:page]
		elsif params[:search].to_i > 0
			@items.joins(:items_wards, :wards).where("ward_number = ?", params[:search].to_i)
						.page params[:page]
		else
			@items.where("lower(title) LIKE ?", "%#{params[:search].downcase}%")
						.page params[:page]
		end
	end

	def show 
		@item = Item.find params[:id]
		@user_vote = UserVote.new

		unless current_user == nil
			@past_vote = @item.user_votes.where(user_id: current_user.id, item_id: @item.id)
			@past_vote = @past_vote.first.vote unless @past_vote.count == 0 
		end
	end
	
	def edit
		@item = Item.find params[:id]
		authorize! :update, @item, message: "You are not allowed to edit this item."
	end

	def update
		@item = Item.find params[:id]

			if @item.update_attributes item_params
					redirect_to item_path(@item)
			else
				render :show
			end
	
	end

	private 
	def new_item_for_current_user(item)
		item.user_votes.where("user_id = #{current_user.id}").empty?
	end

	def item_params
		params.require(:item).permit(:synopsis)
	end
end
