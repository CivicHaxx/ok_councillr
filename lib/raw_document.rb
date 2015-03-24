class RawDocument
	include Scraper

	attr_reader :id
	
	def initialize(doc_type, id)
		@meeting_id   = id
		@raw_file_dir = raw_file_dir(doc_type)
		@filename     = "#{@raw_file_dir}/#{@id}.html"
		@url          = "viewPublishedReport.do?"
		@query        = get_query(doc_type)
	end

	def content
		content = post(@url, agenda_params)
		content.to_s
					 .scrub
					 .encode(
						 'UTF-8', 
						 { :invalid => :replace, 
							 :undef   => :replace, 
							 :replace => '�'
						 })
	end

	def agenda_params
	  {
	    function:  @query,
	    meetingId: @meeting_id
	  }
	end

	def get_query(doc_type)
		case doc_type
		when :agendas then "getCouncilAgendaReport"
		when :minutes then "getCouncilMinutesReport"
		end	
	end

end
