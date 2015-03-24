require 'meeting_ids'
require 'raw_document'
require 'parsed_item'

class AgendaScraper
  include Scraper

  def initialize
    @raw_file_dir = raw_file_dir(:agendas)
    @ids          = MeetingIDs.new(12, 2014).ids
  end

  def get_agendas
    @ids.map do |id| # Check if the file exists, if not, download it.
      file_name = "#{@raw_file_dir}/#{id}.html"
      unless File.exist? file_name
        print "Calling the internet and saving agenda #{id}".yellow
        save(file_name, RawDocument.new(:agendas, id).content)
        puts " ✔ "
      end
    end  
  end
  
  def parse_agendas
  # Temporarily remove the loop for OKC
  # @ids.each do |id|
    id = "7849"
    print "\nParsing #{id} "
    
    content      = open("#{@raw_file_dir}/#{id}.html").read
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
  			Item.create!(parsed_agenda_item)
        print "⚡"
  		end
  	end
  # end
  end

  def run
    get_agendas
    parse_agendas
    puts "\n★ ★ ★  DONE PARSING ★ ★ ★".green
  end
end