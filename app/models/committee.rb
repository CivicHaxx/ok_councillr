class Committee < ActiveRecord::Base
	has_and_belongs_to_many :councillors, dependent: :destroy
	has_many :agendas, dependent: :destroy
end
