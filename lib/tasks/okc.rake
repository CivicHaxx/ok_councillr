# TO DO: Make a scraper class that takes params to tell it which scraper to
#   run. This Scraper class will be home to methods like save, file_name, 
#   parse, scrub (or deep_clean) etc. It will delegate the scraping task
#   to the correct sub class (agenda, votes, minutes, etc).


namespace :okc do
  desc "Gimme a fresh start. Drops the db and parses the data again."
  task fresh: ['db:drop', 'db:create', 'db:migrate', :agendas, 'db:seed'] do
    puts "You look great today.".magenta_on_white
  end

  desc"Clears out items table"
  task destroy_items: :environment do
  	Item.destroy_all
  end

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

  desc "Scrapes, parses & persists raw vote records"
  task :vote_scrape do
    require 'vote_scraper'
    VoteScraper.new(6).run
  end

  desc "Scrape, parse & persist City Council agendas"
  task :agendas do |t|
    ## move all this to seeds?
  	puts "Creating Item Types".blue
    item_types = ItemType.create!([
      { name: 'Action' }, 
      { name: 'Information' }, 
      { name: 'Presentation' }
    ])
  end

end
