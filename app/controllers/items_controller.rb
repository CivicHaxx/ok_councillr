class ItemsController < ApplicationController
	helper_method :display_user_votes_for, :new_item_for_current_user

	def index
		@items = Item.all.page params[:page]
	end

	def show 
		@item = Item.find params[:id]
		@user_vote = UserVote.new
	end

	private 

	def new_item_for_current_user(item)
		item.user_votes.where("user_id = #{current_user.id}").empty?
	end
end
