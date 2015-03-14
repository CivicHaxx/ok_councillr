class Councillor < ActiveRecord::Base
	has_and_belongs_to_many :committees
	has_many :motions
end
