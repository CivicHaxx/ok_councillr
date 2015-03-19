class UsersController < ApplicationController
  def show
    @user = current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @item = Item.first 
    
    if @user.save
      auto_login(@user)
      redirect_to item_url(@item), notice: "Your account has been created"
    else
      flash.now.alert = "Error creating account"
      render :new
    end
  end

  def update
    @user = current_user
    
    if @user.update_attributes(user_params)
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
