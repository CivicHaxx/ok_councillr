class RawAgenda
	include Scraper

	attr_reader :id
	
	def initialize(id)
		super
		@id           = id
		@raw_file_dir = raw_file_dir("agendas")
		@filename     = "#{@raw_file_dir}/#{@id}.html"
		@url          = URI "viewPublishedReport.do?"
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