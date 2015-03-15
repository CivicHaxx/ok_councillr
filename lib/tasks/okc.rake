namespace :okc do
  desc "Gimme a fresh start. Drops the db and parses the data again."
  task get_fresh: ['db:drop', 'db:setup', :delete_items, :agenda_scrape] do;
   45.times do |i|
      Ward.create(ward_number: i)
    end 
  end

  desc"Clears out items table"
  task delete_items: :environment do
  	Item.delete_all
  end

  desc "Tests ParsedItem on a single file"
  task test_parser: [:delete_items] do |t| 
    require 'parsed_item'

    content  = open("lib/dirty_agendas/7849.html").read
    sections = content.split("<br clear=\"all\">")
    items    = sections.map { |item| Nokogiri::HTML(item) }
    
    items.each do |item|
      item_number = item.xpath("//table[@class='border']/tr/td/font[@size='5']").text

      unless item_number.empty?
        parsed_agenda_item = ParsedItem.new(item_number, item).to_h
        Item.create(parsed_agenda_item)

      #binding.pry if parsed_agenda_item[:ward].length > 1 
      end
    end
  end

  desc "Scrape, parse & persist raw vote records"
  task :vote_scrape do
    require 'vote_scraper'
    VoteScraper.new(6).run
  end


  desc "Scrape, parse & persist City Council agendas"
  task :agenda_scrape, [:clean] do |t, args|
  	# Cleaner dosn't work yet. So don't pass any args into the task.
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
    # DIRTY      = args.clean == "-d" ? true : false
    # DIRTY by default so that we're working with the original docs.
    # Remove this when we have a better cleaner working.
    DIRTY      = true
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
      # For testing sanatize
      # DirtyAgenda.create(id: id, dirty_html: content)
  		sections = content.split("<br clear=\"all\">")
  		items    = sections.map { |item| Nokogiri::HTML(item) }
  		
      items.each do |item|
  			item_number = item.xpath("//table[@class='border']/tr/td/font[@size='5']").text

  			unless item_number.empty?
  				parsed_agenda_item = ParsedItem.new(item_number, item).to_h
  				Item.create(parsed_agenda_item)
  			end
  		end
  	  puts "⚡" * ((Time.now.to_f - start)*50)
  	end

  	puts "★ ★ ★  DONE ★ ★ ★"
  end

end
