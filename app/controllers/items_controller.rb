class ItemsController < ApplicationController
	helper_method :display_user_votes_for, :new_item_for_current_user

	def index
		@items = Item.where(item_type_id: 1).includes(:user_votes).page params[:page]
	end

	def show 
		@item = Item.find(params[:id])
		@user_vote = UserVote.new

		unless current_user == nil
			@past_vote = @item.user_votes.where(user_id: current_user.id, item_id: @item.id)
			@past_vote = @past_vote.first.vote unless @past_vote.count == 0 
		end
	end

private 
	def new_item_for_current_user(item)
		item.user_votes.where("user_id = #{current_user.id}").empty?
	end
end
