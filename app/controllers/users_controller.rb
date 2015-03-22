class UsersController < ApplicationController
  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      auto_login(@user)
      redirect_to edit_user_path(@user.id), notice: "Your account has been successfully activated."
    else
      not_authenticated
    end
  end

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
      redirect_to item_url(@item), notice: "Your account has been created"
    else
      flash.now.alert = "Error creating account"
      render :new
    end
  end

  def update
    @user = current_user
    
    if @user.update_attributes(user_params)
      redirect_to edit_user_path(params[:id]), notice: "Your account has been updated"
    else
      flash.now.alert = "Error updating account"
      render :edit
    end
  end

  def edit
    @user = User.find(params[:id]) 
  end

  def destroy
    @user = User.find(params[:id])
    @item = Item.first
    @user.destroy

    logout
    redirect_to item_url(@item), notice: "Your account has been deleted"
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
