class ItemsController < ApplicationController
	helper_method :display_user_votes_for

	def index
		@items = Item.all.page params[:page]
	end

	def show 
		@item = Item.find params[:id]
		@user_vote = UserVote.new
	end

	private 
	def display_user_votes_for(item)
		display_user_votes = []
		user_votes         = %w(Yes No Skip)

		user_votes.each do |user_vote|
			display_user_votes << item.user_votes.where(vote: user_vote).count
		end

		display_user_votes.join('-')
	end
end
