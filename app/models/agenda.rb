class Agenda < ActiveRecord::Base
	belongs_to :committees

	has_many :items, as: origin
end
