class Item < ActiveRecord::Base
	serialize :sections, Hash
	
	belongs_to :item_type
	belongs_to :origin, polymorphic: true

	has_many :user_votes, dependent: :destroy
	has_many :motion, dependent: :destroy
	has_and_belongs_to_many :wards

	accepts_nested_attributes_for :user_votes

	def next
		Item.where("id > ?", id).first 
	end

	def count_votes(vote)
		user_votes.where(vote: vote).count
	end

	def count_yes
		count_votes "Yes"
	end

	def count_no
		count_votes "No"
	end

	def count_skip
		count_votes "Skip"
	end

	def result
		if count_yes > count_no && count_yes > count_skip
			:carried
		elsif count_no > count_yes && count_no > count_skip
			:lost
		else
			:pending
		end
	end

end
