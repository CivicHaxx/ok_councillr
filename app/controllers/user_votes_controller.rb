class UserVotesController < ApplicationController
 before_filter :load_item

def show
end

def new	
	@user_vote = UserVote.new
end

def create
	@user_vote = @item.user_votes.build(vote_params)
	@user_vote.user = current_user

	if @user_vote.save
      redirect_to item_path(@item.next)
    else
      render 
    end
end


private
	def load_item
	  @item = Item.find(params[:item_id])
	end

  def vote_params
  params.require(:user_vote).permit(
    :vote,
    :item_id,
    :user_id
    )
	end
	
end
