class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @votes = @user.user_votes.page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to items_path, notice: "Your account has been created"
    else
      flash.now.alert = "Error creating account"
      render :new
    end
  end

  def update
    @user = User.update_atrributes(user_params)
    if @user.save
      redirect_to user_path(params[:id]), notice: "Your account has been updated"
    else
      flash.now.alert = "Error updating account"
      render :edit
    end
  end

  def edit
    @user = User.find(params[:id]) 
  end

  def destroy
  end

  private
  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      :postal_code
    )
  end
end
