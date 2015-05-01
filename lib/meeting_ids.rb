class MeetingIDs
	include Scraper

	attr_reader :ids

	# TO DO: Pass scrape decision body IDs and pass them into this class to get
	# 			 meeting IDs for different committees.
	def initialize(date)
		@now           = date
		@decision_body = "961"
		@ids           = meeting_ids
	end

	private

	def meeting_ids
		page        = meeting_page
		headers     = page.css("h3").to_ary
		headers.map do |header|
		  header.attr("id").remove("header") if past_meeting? header
		end.flatten.reject(&:nil?)
	end

	def meeting_page
  	url  = "decisionBodyProfile.do?function=doPrepare&decisionBodyId=#{@decision_body}"
		page = get url
		Nokogiri::HTML(page)
	end

	def past_meeting?(header)
		meeting_date = DateTime.parse(header.text.split("-")[0].strip)
		@now - meeting_date > 0 ? true : false
	end

end