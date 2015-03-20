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

	def get_user_votes_for(vote_type)
		votes = Array.new(0)

		user_votes.each { |user_vote| votes << user_vote if user_vote.vote == vote_type }

		votes
	end

	def count_yes
		get_user_votes_for("Yes").count
	end

	def count_no
		get_user_votes_for("No").count
	end

	def count_skip
		get_user_votes_for("Skip").count
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
