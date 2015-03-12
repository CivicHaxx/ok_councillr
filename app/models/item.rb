class Item < ActiveRecord::Base
	belongs_to :item_type
	belongs_to :agenda

	has_many :user_votes
end
