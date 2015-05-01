class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  rescue_from CanCan::AccessDenied do |exception|
    @item = Item.where(item_type_id: 1).first if @item == nil

    redirect_to item_path(@item), :notice => exception.message
  end

  def find_next_item(user)
    if user.nil? || user.has_no_votes?
  		Item.where(item_type_id: 1).first
  	else
	  	get_items_to_vote_on(user).order(:id).first.id
	  end
	end
	helper_method :find_next_item

  def get_item_id_from_vote(user)
    User.includes(:user_votes).where(id: user.id).pluck(:item_id)
  end

  def get_items_to_vote_on(user) 
    Item.where('id NOT IN (?)', get_item_id_from_vote(user)).where(item_type_id: 1)
  end
end
