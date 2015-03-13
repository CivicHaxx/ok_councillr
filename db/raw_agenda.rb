class RawAgenda
	attr_reader :id
	
	def initialize(id)
		@id = id
	end

	def name
		"#{@id}.html"
	end

	def filename
		"db/agendas/#{name}"
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

	def content
		var = Net::HTTP.post_form(url, agenda_params(id)).body
		var.to_s
			 .scrub
			 .encode(
			 	'UTF-8', 
			 	{ :invalid => :replace, 
			 		:undef   => :replace, 
			 		:replace => '?'})
		# parser = Ox::Sax::Stripper.new
		# parser.parse!(content).to_s
	end

	def save
		File.open(filename, 'w') {|f| f.write(content) }	  
	end
end