class Councillor < ActiveRecord::Base
	belongs_to :ward

	has_and_belongs_to_many :committees
	has_many :motions
	has_many :items, as: origin
end
