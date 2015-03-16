class UserVotesController < ApplicationController
 before_filter :ensure_logged_in, only: [:create]
 before_filter :load_item

def show
end

def new	
	@user_vote = UserVote.new
end

def create
	# @user_vote = UserVote.find(params[:item_id])	
	# respond_to do |format|
 #      if @user_vote.save
 #        format.html 
 #        format.js 
 #      else
 #        format.html 
 #        format.js 
 #      end
 #    end    
end


private
	def load_item
	  @item = Item.find(params[:item_id])
	end
	
end
