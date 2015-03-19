class PasswordResetsController < ApplicationController
	skip_before_filter :require_login

  def create
  	@user = User.find_by_email(params[:email])

  	@user.deliver_reset_password_instructions! if @user

  	redirect_to :login, notice: 'Instructions have been sent to your email'
  end

  def edit
  	@token = params[:id]
  	@user = User.load_from_reset_password_token(params[:id])

  	if @user.blank?
  		not_authenticated
  		return
  	end
  end

  def update
  	@token = params[:id]
  	@user = User.load_from_reset_password_token(params[:id])

  	if @user.blank?
  		not_authenticated
  		return
  	end

  	@user.password_confirmation = params[:user][:password_confirmation]

  	if @user.change_password!(params[:user][:password])
      auto_login(@user)
  		redirect_to root_path, notice: 'Reset Password was successfully'
  	else
  		render action: :edit
  	end
  end
end
