require 'active_record'
require 'active_support/all'
require 'awesome_print'
require 'colored'
require 'csv'
require 'http'
require 'nokogiri'
require 'open-uri'

require 'scraper'
require 'vote_scraper'
require 'agenda_scraper'
require 'parsed_item'
require 'minutes_scraper'

namespace :okc do
  
  ##################################################################
  #                                                                #
  # GET FRESH                                                      #
  #                                                                #
  ##################################################################

  desc "Gimme a fresh start. Drops the db and parses the data again."
  task fresh: [:environment, 'db:drop', 'db:create', 'db:migrate', :agendas, 'db:seed', :votes] do
    puts "############################".magenta_on_white
    puts "                            ".magenta_on_white
    puts "💖  You look great today!  💖 ".magenta_on_white
    puts "                            ".magenta_on_white
    puts "############################".magenta_on_white
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
    # Rake.application.rake_require File.expand_path('../../../app/models/raw_vote_record.rb', __FILE__)
    puts "Destroying the vote record".red
    RawVoteRecord.destroy_all
    VoteScraper.new(6, "2015-01-01", "2015-04-30").run
    # to change the date range and the term for the votes, you need
    # to changne the above info and change the params for getting 
    # the csvs. e.g., The decision body ID for 2014 is 961 but it is
    # 261 for last term.
  end

  ##################################################################
  #                                                                #
  # AGENDA SCRAPER                                                 #
  #                                                                #
  ##################################################################
  
  desc "Scrape, parse & persist City Council agendas"
  task :agendas do |t|
    puts "Creating Item Types".blue
    item_types = ItemType.create!([
      { name: 'Action' }, 
      { name: 'Information' }, 
      { name: 'Presentation' }
    ])
    # TODO: Move this into its own scraper
    puts "Destroying Committees".red
    Committee.destroy_all
    puts "Creating City Council".blue
    @council = Committee.create!({
      name: "City Council",
    })
    AgendaScraper.new(DateTime.now).run
  end

  ##################################################################
  #                                                                #
  # MINUTES SCRAPER                                                #
  #                                                                #
  ##################################################################
  
  desc "Scrape Minutes"
  task :minutes do |t|
    MinutesScraper.new.run
  end

end
