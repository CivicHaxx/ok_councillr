class RawAgenda
	attr_reader :id
	def initialize(id)
		@id = id
	end

	def name
		"#{@id}.html"
	end

	def filename
		"#{AGENDA_DIR}/#{name}"
	end

	def url
		URI "#{BASE_URI}viewPublishedReport.do?"
	end

	def agenda_params(meeting_id)
	  {
	    function:  "getCouncilAgendaReport",
	    meetingId: meeting_id
	  }
	end

	def post(form)
		HTTP.with_headers("User-Agent" => "INTERNET EXPLORER").post(url, form: form).body
	end

	# TO DO: hook up the html stripper and start using clean data! 
	def content
		content = post(agenda_params(id))
		# content = Net::HTTP.post_form(url, agenda_params(id)).body
		content = content.to_s
					 					 .scrub
					 					 .encode(
					 						 'UTF-8', 
					 						 { :invalid => :replace, 
					 							 :undef   => :replace, 
					 							 :replace => '�'
					 						 })
		if DIRTY
			content
		else
			parser  = HTMLCleaner.new
			content = parser.parse_html!(content).to_s
			content
		end
	end

	def save
		File.open(filename, 'w') {|f| f.write(content) }	  
	end
end