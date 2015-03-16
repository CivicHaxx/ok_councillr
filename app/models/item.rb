class Item < ActiveRecord::Base
	serialize :sections, Hash
	
	belongs_to :item_type
	belongs_to :origin, polymorphic: true

	has_many :user_votes, dependent: :destroy
	has_many :motion, dependent: :destroy
	has_and_belongs_to_many :wards
end
