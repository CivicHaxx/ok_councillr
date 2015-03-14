namespace :okc do
  desc "Gimme a fresh start. Drops the db and parses the data again."
  task get_fresh: ['db:drop', 'db:create', 'db:migrate', :agenda_scrape] do; end

  desc"Clears out items table"
  task delete_items: :environment do
  	Item.delete_all
  end

  desc "Scrape, parse & persist City Council agendas"
  task :agenda_scrape, [:clean] do |t, args|
  	args.with_defaults clean: "-c"
		require 'http'
  	require 'nokogiri'
  	require 'open-uri'
  	require 'awesome_print'
  	require 'raw_agenda'
  	require 'parsed_item'
  	require 'meeting_ids'
  	require 'html_stripper'

  	BASE_URI   = "http://app.toronto.ca/tmmis/"
  	DIRTY      = args.clean == "-d" ? true : false
  	AGENDA_DIR = DIRTY == true ? "lib/dirty_agendas" : "lib/agendas"

  	ids = MeetingIDs.new(12, 2014).ids
  	
  	ids.map do |id|
  		unless File.exist? "#{AGENDA_DIR}/#{id}.html"
  		  print "Saving #{id}"
  			RawAgenda.new(id).save
  			puts " ✔ "
  		end
  	end

  	ids.each do |id|
  		start = Time.now.to_f
  	  print "Parsing #{id} "
  	  content  = open("#{AGENDA_DIR}/#{id}.html").read
  		# start working here start using new xpaths
  		sections = content.split("<br clear=\"all\">")
  		items    = sections.map { |item| Nokogiri::HTML(item) }
  		items.each do |item|
  			item_number = item.xpath("//table[@class='border']/tr/td/font[@size='5']").text
  			
  			unless item_number.empty?
  				parsed_agenda_item = ParsedItem.new(item_number, item).to_h
  				Item.create(parsed_agenda_item)
  			end
  		end
  	  puts "⚡" * ((Time.now.to_f - start)*500)
  	end

  	puts "★ ★ ★  DONE ★ ★ ★"
  end

end
