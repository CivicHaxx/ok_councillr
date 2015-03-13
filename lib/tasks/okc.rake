namespace :okc do
  desc "Scrape, parse & persist City Council agendas"
  task agenda_scrape: :environment do
  	begin
	  	require          "net/http"
	  	require          "nokogiri"
	  	require          "open-uri"
	  	require          "awesome_print"
	  	require_relative "raw_agenda"
	  	require_relative "parsed_item"
	  	require_relative "../html_stripper"

	  	BASE_URI = "http://app.toronto.ca/tmmis/"
	  	AGENDA_DIR = "lib/agendas"

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
	  	# TO DO: Make meetingId class that takes params like year, committee name etc.
	  	#        and generates a list of meeting ids to be passed into RawAgenda
	  	
	  	calendar_uri  = URI("#{BASE_URI}meetingCalendarView.do")
	  	calendar_page = Net::HTTP.post_form(calendar_uri, calendar_params(12, 2014)).body
	  	page          = Nokogiri::HTML(calendar_page)
	  	anchors       = page.css("#calendarList .list-item a")
	  	anchors       = anchors.to_ary

	  	meeting_ids = anchors.map do |a|
	  	  a.attr("href").split("=").last if a.text.include? "City Council"
	  	end.reject(&:nil?).uniq.flatten

	  	puts "I found #{meeting_ids.length} meeting IDs."

	  	#Dir.mkdir("#{AGENDA_DIR}") unless Dir.exist? "#{AGENDA_DIR}"

	  	meeting_ids.map do |id|
	  		unless File.exist? "#{AGENDA_DIR}/#{id}.html"
	  			RawAgenda.new(id).save
	  		  puts "Saved #{id} ✔ "
	  		end
	  	end

	  	meeting_ids.each do |id|
	  	  puts "Parsing #{id} ⚡  "
	  	  content  = open("#{AGENDA_DIR}/#{id}.html").read
	  		sections = content.scrub.split("<br clear=\"all\">")
	  		items    = sections.map { |item| Nokogiri::HTML(item) }
	  		items.each do |item|
	  			item_number = item.xpath("//table[@class='border']/tr/td/font[@size='5']").text
	  			
	  			unless item_number.empty?
	  				parsed_agenda_item = ParsedItem.new(item_number, item).to_h
	  				Item.create(parsed_agenda_item)
	  			end
	  		end
	  	end

	  	puts "★ ★ ★  DONE ★ ★ ★"
	  rescue
	  	puts "-----------------------------------------------------------"
	  	puts
	  	puts "Looks like your database isn't set up yet!"
	  	puts
	  	puts "Usage:" 
	  	puts "      rake db:drop db:create db:migrate okc:agenda_scrape"
	  	puts
	  	puts "-----------------------------------------------------------"
	  end
  end

end
