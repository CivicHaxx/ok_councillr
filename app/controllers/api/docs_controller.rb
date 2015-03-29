class Api::DocsController < ApplicationController
	helper_method :get_url_query_parameters_for

	COUNCILLOR_JSON_PATH = Rails.root.join('db/data/api/councillors.json')
	ITEM_JSON_PATH = Rails.root.join('db/data/api/item.json')

	def index
		councillors_json = COUNCILLOR_JSON_PATH.read
		item_json        = ITEM_JSON_PATH.read
		@councillors     = "<code lang=\"JSON\">#{councillors_json}</code>"
		@item            = "<code lang=\"JSON\"> #{item_json}</code>"
	end

	def get_url_query_parameters_for(section)
		case section
			when :Agendas
			when :Councillors
			when :Committees
			when :Items
			when :Motions
			when :Wards
		end
	end
end
