class RawDocument
	include Scraper

	attr_reader :id
	
	def initialize(doc_type, id)
		@id           = id
		@raw_file_dir = raw_file_dir(doc_type)
		@filename     = "#{@raw_file_dir}/#{@id}.html"
		@url          = "viewPublishedReport.do?"
		@query        = get_query(doc_type)
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

	def get_query(doc_type)
		case doc_type
		when :agendas then "getCouncilAgendaReport"
		when :minutes then "getCouncilMinutesReport"
		end	
	end

end
