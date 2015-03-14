include ActionView::Helpers

class ParsedItem
	attr_reader :number, :type, :ward, :title, :sections, :recommendations
	
	# TO DO: 
	# 	1. Get rid of the word "Ward" in the ward var and create a foreign key instead
	#   2. Break sections out for better granularity -- this requires updating the migration
	#   3. get item_type_id from the type name

	def initialize(item_number, item)
		@item            = item

		@number          = item_number
		@type            = find_item_type
		@ward            = find_ward
		@title           = find_item_title
		@sections        = hash_sections(raw_html)
		@recommendations = @sections[:recommendations]

		@item = nil
	end

	def to_h
		{
			number:          @number,
			# type:            @type,
			ward:            @ward,
			title:           @title,
			sections:        @sections,
			recommendations: @recommendations
		}
	end

	def to_s
		[
			"Number: #{@number}",
			"Title: #{@title}",
			"Ward: #{@ward}",
			"Type: #{@type}",
			"-------",
			@sections.to_a.join("\n")
		].join("\n")
	end

	private
	attr_reader :item
	def find_item_type
		item.xpath("//table[@class='border']/tr/td/p/font").first.text.capitalize.chop
	end

	def find_ward
		item.xpath("//table[@class='border']/tr/td/p/font").last.text.chop
	end

	def find_item_title
		item.xpath('//table/tr/td/font/b').first.text
	end

	def raw_html
		item_tables = item.xpath('//table')
		item.xpath('//table')[2..item_tables.length]
	end

	def hash_sections(contents)
		keywords = [
			"Recommendations",
			"Decision Advice and Other Information",
			"Origin",
			"Summary",
			"Background Information",
			"Speakers",
			"Communications",
			"Declared Interests"
		]

		sections = Hash.new('')
		current_section = ""

		contents.css('td').map do |node|
			if node.css('p').length > 0
				sections[current_section] << node.css('p').map(&:text).join(" ")
			elsif node.css('b').length > 0 && keywords.any? { |keyword| node.text[keyword] }
				current_section = node.text.downcase.gsub(" ", "_").to_sym
				sections[current_section] = ""
			else
				content = node.to_s
				sections[current_section] << sanitize(content, tags: %w(p))
			end
		end.flatten
		sections
	end
end