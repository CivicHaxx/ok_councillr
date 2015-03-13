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

	# TO DO: hook up the html stripper and start using clean data! 
	def content
		content = Net::HTTP.post_form(url, agenda_params(id)).body
		content.to_s
					 .scrub
					 .encode(
					 	'UTF-8', 
					 	{ :invalid => :replace, 
					 		:undef   => :replace, 
					 		:replace => '?'
					 	})
		# parser = Ox::Sax::Stripper.new
		# parser.parse!(content).to_s
	end

	def save
		File.open(filename, 'w') {|f| f.write(content) }	  
	end
end