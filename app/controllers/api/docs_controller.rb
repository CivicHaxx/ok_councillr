class Api::DocsController < ApiController
	def index
		@text = "<p>Some text</p><code lang=\"json\"> {
		  \"councillors\": [{
				\"id\": 1,
				\"first_name\": \"Paul\",
				\"last_name\": \"Ainslie\",
				\"start_date_in_office\": \"2015-03-08\",
				\"website\": \"http://reynolds.com/chanelle_powlowski\",
				\"twitter_handle\": \"voluptatem\",
				\"facebook_handle\": \"facere\",
				\"email\": \"michael_cartwright@example.org\",
				\"phone_number\": \"700-644-8668\",
				\"address\": \"57097 Toy Run\",
				\"image\": \"http://robohash.org/sitetqui.png?size=300x300\"
	    }]
		} </code>"
	end
end
