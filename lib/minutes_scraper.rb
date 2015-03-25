require 'meeting_ids'
require 'raw_document'

class MinutesScraper
  include Scraper

  def initialize
    @raw_file_dir = raw_file_dir(:minutes)
    @ids          = MeetingIDs.new(12, 2014).ids
  end

  def get_minutes
    #@ids.map do |id| # Check if the file exists, if not, download it.
    id = "7849"
      file_name = "#{@raw_file_dir}/#{id}.html"
      unless File.exist? "#{@raw_file_dir}/#{id}.html"
        print "Calling the internet and saving minutes #{id}".yellow
        save(file_name, RawDocument.new(:minutes, id).content)
        puts " ✔ "
      end
    #end  
  end
  
  def parse_minutes
  # Temporarily remove the loop for OKC
  # @ids.each do |id|
    id = "7849"
    print "\nParsing #{id} "
    
    content      = open("#{@raw_file_dir}/#{id}.html").read
    sections     = content.split("<br clear=\"all\">")
    items        = sections.map { |item| Nokogiri::HTML(item) }
    @header_info = Nokogiri::HTML(items[1].to_s.split('<hr')[0])

    binding.pry
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

    @minutes = Minutes.create!({
      date:         date,
      meeting_num:  meeting_num,
      committee_id: council.ids[0]
    })
  	
    items.each do |item|
  		item_number = item.xpath("//table[@class='border']/tr/td/font[@size='5']").text

  		unless item_number.empty?
  			parsed_minutes_item = ParsedItem.new(item_number, item).to_h
        parsed_agenda_item[:origin_id] = @minutes.id
        parsed_agenda_item[:origin_type] = "Agenda"
  			Item.create!(parsed_agenda_item)
        print "⚡"
  		end
  	end
  # end
  end

  def run
    get_minutes
    parse_minutes
    puts "\n★ ★ ★  DONE PARSING ★ ★ ★".green
  end
end