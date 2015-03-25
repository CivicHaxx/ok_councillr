class Councillor < ActiveRecord::Base
	belongs_to :ward

	has_and_belongs_to_many :committees, dependent: :destroy
	has_many :motions, dependent: :destroy
	has_many :councillor_votes, dependent: :destroy
	has_many :raw_vote_records, dependent: :destroy
	has_many :items, as: :origin, dependent: :destroy
end
