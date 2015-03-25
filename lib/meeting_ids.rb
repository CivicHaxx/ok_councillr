class MeetingIDs
	include Scraper

	attr_reader :ids

	def initialize(month, year)
		@month    = month
		@year     = year
		@ids      = meeting_ids
	end

	private

	def meeting_ids 
		page    = calendar_page
		anchors = page.css("#calendarList .list-item a").to_ary
		
		anchors.map do |a|
	  	a.attr("href").split("=").last if a.text.include? "City Council"
		end.reject(&:nil?)
			 .uniq
			 .flatten
	end

	def calendar_page
  	url  = URI("meetingCalendarView.do")
		page = post(url, calendar_params(@month, @year))
		Nokogiri::HTML(page)
	end
	
	def calendar_params(month, year)
	  {
	    function:      "meetingCalendarView",
	    isToday:       "false",
	    expand:        "N",
	    view:          "List",
	    selectedMonth: month,
	    selectedYear:  year,
	    includeAll:    "on"
	  }
	end

end