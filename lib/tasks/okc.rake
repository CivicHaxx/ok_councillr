namespace :okc do
  
  ##################################################################
  #                                                                #
  # GET FRESH                                                      #
  #                                                                #
  ##################################################################

  desc "Gimme a fresh start. Drops the db and parses the data again."
  task fresh: ['db:drop', 'db:create', 'db:migrate', :agendas, 'db:seed'] do
    puts "You look great today.".magenta_on_white
  end

  desc"Clears out items table"
  task destroy_items: :environment do
  	Item.destroy_all
  end

  ##################################################################
  #                                                                #
  # TEST PARSER                                                    #
  #                                                                #
  ##################################################################
  
  desc "Tests ParsedItem on a single file"
  task test_parser: [:destroy_items] do |t| 
    require 'parsed_item'

    content  = open("lib/dirty_agendas/7849.html").read
    sections = content.split("<br clear=\"all\">")
    items    = sections.map { |item| Nokogiri::HTML(item) }
    
    items.each do |item|
      item_number = item.xpath("//table[@class='border']/tr/td/font[@size='5']").text

      unless item_number.empty?
        parsed_agenda_item = ParsedItem.new(item_number, item).to_h
        Item.create(parsed_agenda_item)

      end
    end
  end

  ##################################################################
  #                                                                #
  # VOTE SCRAPER                                                   #
  #                                                                #
  ##################################################################

  desc "Scrapes, parses & persists raw vote records"
  task :votes do
    require "http"
    require "awesome_print"
    require "colored"
    require "csv"
    require "pry"
    require "nokogiri"
    require "open-uri"
    require "active_support/all"
    require "active_record"
    require 'scraper'
    require 'vote_scraper'
    VoteScraper.new(6).run
  end

  ##################################################################
  #                                                                #
  # AGENDA SCRAPER                                                 #
  #                                                                #
  ##################################################################
  
  desc "Scrape, parse & persist City Council agendas"
  task :agendas do |t|
    require 'awesome_print'
    require 'colored'
    require 'http'
    require 'nokogiri'
    require 'open-uri'
    require 'scraper'
    require 'agenda_scraper'
    
  	puts "Creating Item Types".blue
    item_types = ItemType.create!([
      { name: 'Action' }, 
      { name: 'Information' }, 
      { name: 'Presentation' }
    ])
    AgendaScraper.new.run
  end

end
