class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def find_next_item(user)
  	if user.nil? || user.has_no_votes?
  		Item.first.id
  	else
	  	Item.where('id NOT IN (?)', User.includes(:user_votes).where(id: user.id).pluck(:item_id)).order(:id).first.id
	  end
	end
	helper_method :find_next_item

end
