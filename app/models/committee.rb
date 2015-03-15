class Committee < ActiveRecord::Base
	has_and_belongs_to_many :councillors
	has_many :agendas
end
