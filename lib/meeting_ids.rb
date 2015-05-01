class MeetingIDs
	include Scraper

	attr_reader :ids

	def initialize(date)
		@month = date.month
		@year  = date.year
		@ids   = meeting_ids
	end

	private

	def meeting_ids
		page        = meeting_page
		headers     = page.css("h3").to_ary
		
		ids = headers.map do |header|
		  header.attr("id").remove("header") if !future? header
		end.flatten.reject(&:nil?)
			 binding.pry; 1
	end

	def meeting_page
  	url  = URI "http://app.toronto.ca/tmmis/decisionBodyProfile.do?function=doPrepare&decisionBodyId=961"
		page = HTTP.get(url).to_s
		Nokogiri::HTML(page)
	end

	def future?(header)
		month_names = %w(January February March April May June July August September October November December)
		binding.pry
		month_names[0..@month-1].map do |month|
			unless header.text.include?(month) || !header.text.include?(@year.to_s)
				false
			end
		end
	end

end