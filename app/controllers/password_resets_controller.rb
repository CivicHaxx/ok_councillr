class PasswordResetsController < ApplicationController
	skip_before_filter :require_login

  def create
  	@user = User.find_by_email(params[:email])

  	@user.deliver_reset_password_instructions! if @user

  	redirect_to :login, notice: 'Instructions have been sent to your email'
  end

  def edit
  end

  def update
  end
end
