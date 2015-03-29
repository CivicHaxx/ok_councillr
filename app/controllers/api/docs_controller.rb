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
				{
					committee_id: "Search for an Agenda by their Committee ID"
				}
			when :Councillors
				{
					ward_id: "Display the councillor who is representing this ward",
					counciillor_name: "Search for councillor using their name",
					date: "Search for councillor base on when they started in office, in format dd/mm/yyyy. Also you can have a range by using '<em>,</em>' between the date."
				}
			when :Committees
				{
					councillor_id: "Search for the committees of a councillor by their ID"
				}
			when :Items
				{
					item_type_id: "Search for all items with this type ID",
					agenda_id: "Search for all items with this agenda ID",
					councillor_id: "Search for all items with this councillor ID"
				}
			when :Motions
				{
					councillor_id: "Search for all motions by a councillor ID",
					item_id: "Search for all motions with this item ID",
					motion_type_id: "Search for all motions with this type ID"
				}
		end
	end
end
