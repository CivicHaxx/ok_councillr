class Item < ActiveRecord::Base
	serialize :sections, #this should make a conflict


	belongs_to :item_type
	belongs_to :agenda

	has_many :user_votes

end
