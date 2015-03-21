require 'scraper'
require 'raw_agenda'
require 'parsed_item'
require 'meeting_ids'

class AgendaScraper < Scraper

  def initialize
    super
    @raw_dir = raw_dir("agendas")
    # ids can be moved to parent when scraping other doc types
    # or create parent called meeting scraper
    @ids     = MeetingIDs.new(12, 2014).ids
  end

  def get_agendas
    @ids.map do |id| # Check if the file exists, if not, download it.
      unless File.exist? "#{@raw_dir}/#{id}.html"
        print "Calling the internet and saving agenda #{id}".yellow
        RawAgenda.new(id).save
        puts " ✔ "
      end
    end  
  end
  
  def parse
  # Temporarily remove the loop for OKC
  # @ids.each do |id|
    id = "7849"
    print "Parsing #{id} "
    
    content      = open("#{@raw_dir}/#{id}.html").read
    sections     = content.split("<br clear=\"all\">")
    items        = sections.map { |item| Nokogiri::HTML(item) }
    @header_info = Nokogiri::HTML(items[1].to_s.split('<hr')[0])

    def date
      @header_info.at('tr[2]/td[2]')
                  .at('br')
                  .previous_sibling
                  .text
                  .strip
    end

    def meeting_num
      @header_info.at('tr/td[2]').text.strip
    end

    # find the date & meeting number and create a meeting in the db
    council = Committee.where("name = 'City Council'")

    @agenda = Agenda.create!({
      date:         date,
      meeting_num:  meeting_num,
      committee_id: council.ids[0]
    })
  	
    items.each do |item|
  		item_number = item.xpath("//table[@class='border']/tr/td/font[@size='5']").text

  		unless item_number.empty?
  			parsed_agenda_item = ParsedItem.new(item_number, item).to_h
        parsed_agenda_item[:origin_id] = @agenda.id
        parsed_agenda_item[:origin_type] = "Agenda"
  			Item.create(parsed_agenda_item)
        print "⚡"
  		end
  	end
  # end
  end

  puts "\n★ ★ ★  DONE PARSING ★ ★ ★".green
end