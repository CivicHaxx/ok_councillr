namespace :okc do
  desc "Gimme a fresh start. Drops the db and parses the data again."
  task get_fresh: ['db:drop', 'db:create', 'db:migrate', :agenda_scrape] do; end

  desc"Clears out items table"
  task delete_items: :environment do
  	Item.delete_all
  end

  desc "Scrape, parse & persist City Council agendas"
  task agenda_scrape: :environment do
  	begin
	  	require "net/http"
	  	require "nokogiri"
	  	require "open-uri"
	  	require "awesome_print"
	  	require "tasks/raw_agenda"
	  	require "tasks/parsed_item"
	  	require "html_stripper"

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

	  	meeting_ids.map do |id|
	  		unless File.exist? "#{AGENDA_DIR}/#{id}.html"
	  			RawAgenda.new(id).save
	  		  puts "Saved #{id} ✔ "
	  		end
	  	end

	  	meeting_ids.each do |id|
	  		start = Time.now.to_f
	  	  print "Parsing #{id} "
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
	  	  puts "⚡" * ((Time.now.to_f - start)*10)
	  	end

	  	puts "★ ★ ★  DONE ★ ★ ★"
	  rescue => error
	  	puts "-----------------------------------------------------------"
	  	puts
	  	puts error
	  	puts
	  	puts "Your database might not be set up yet."
	  	puts
	  	puts "To start fresh, run rake okc:get_fresh"
	  	puts
	  	puts "-----------------------------------------------------------"
	  end
  end

end
