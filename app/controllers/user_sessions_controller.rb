class UserSessionsController < ApplicationController
  def new
  	@user = User.new 
  end

  def create
    @user = current_user

  	if @user = login(params[:email], params[:password])

      @item  = @user.user_votes.last.item_id + 1

  		redirect_back_or_to item_url(@item, notice: 'Login successful')
  	else
  		flash.now[:alert] = 'Login failed'
  		render action: 'new'
  	end
  end

  def destroy

  	logout 
  	redirect_to root_url, notice: 'Logged out!'
  end
end
