class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to items_path, notice: "Your account has been created"
    else
      flash.now("Error creating account")
      render :new
    end
  end

  def update
    @user = User.update_atrributes(user_params)
    if @user.save
      redirect_to user_path(params[:id]), notice: "Your account has been updated"
    else
      flash.now("Error updating account")
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
      :crypted_password,
      :salt,
      :first_name,
      :last_name,
      :postal_code,
      :address
    )
  end
end
