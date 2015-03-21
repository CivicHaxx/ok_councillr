class RawAgenda < AgendaScraper
	attr_reader :id
	
	def initialize(id)
		super
		@id = id
	end

	def name
		"#{@id}.html"
	end

	def filename
		"#{@raw_dir}/#{name}"
	end

	def url
		URI "#{@base_uri}viewPublishedReport.do?"
	end

	def agenda_params(meeting_id)
	  {
	    function:  "getCouncilAgendaReport",
	    meetingId: meeting_id
	  }
	end

	def content
		content = post(url, agenda_params(@id))
		content.to_s
					 .scrub
					 .encode(
						 'UTF-8', 
						 { :invalid => :replace, 
							 :undef   => :replace, 
							 :replace => '�'
						 })
	end

end