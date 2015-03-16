class ItemsController < ApplicationController

	def index
		@items = Item.all.page params[:page]
	end

	def show 
		@item = Item.find params[:id]
		@user_vote = UserVote.find params[:id]
	end

end
