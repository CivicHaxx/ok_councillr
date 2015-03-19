class Api::DocsController < ApplicationController
	COUNCILLOR_JSON_PATH = Rails.root.join('db/data/api/councillors.json')
	ITEM_JSON_PATH = Rails.root.join('db/data/api/item.json')

	def index
		councillors_json = COUNCILLOR_JSON_PATH.read
		item_json        = ITEM_JSON_PATH.read
		@councillors     = "<code lang=\"JSON\">#{councillors_json}</code>"
		@item            = "<code lang=\"JSON\"> #{item_json}</code>"
	end
end
