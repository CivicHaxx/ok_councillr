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
  # VOTE SCRAPER                                                   #
  #                                                                #
  ##################################################################

  desc "Scrapes, parses & persists raw vote records"
  task :votes do
    puts "This does nothing right now. Check the rake file for a To Do note.".yellow
    # TO DO: Pass in the date of the most recent vote record, then get the scraper
    #        to check if there are new votes to scrape
    #VoteScraper.new(6, "2015-01-01", "2015-04-30").run
  end

  ##################################################################
  #                                                                #
  # AGENDA SCRAPER                                                 #
  #                                                                #
  ##################################################################
  
  desc "Scrape, parse & persist City Council agendas"
  task :agendas do |t|
    puts "This does nothing right now. Check the rake file for a To Do note.".yellow
    # TO DO: Pass in the date of the most recend Agenda, then get the scraper
    #        to check if there are any new agendas to scrape.
    # AgendaScraper.new(DateTime.now).run
  end

  ##################################################################
  #                                                                #
  # MINUTES SCRAPER                                                #
  #                                                                #
  ##################################################################
  
  desc "Scrape Minutes"
  task :minutes do |t|
    puts "This does nothing right now. Check the rake file for a To Do note.".yellow
    # TO DO: Get the minuts scraper to parse minuts. This is similar to the agenda
    #        scraper except that minutes have motions.
    # MinutesScraper.new.run
  end

  # TO DO: Create a Decision Document Scraper and parser.

end
