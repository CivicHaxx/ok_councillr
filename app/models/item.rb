class Item < ActiveRecord::Base
	belongs_to :item_type
	has_many :user_votes
end
