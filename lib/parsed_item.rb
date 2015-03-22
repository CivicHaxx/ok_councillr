require 'action_view/helpers'

class ParsedItem
	include ActionView::Helpers
	include Scraper

	attr_reader :number, :type, :ward, :title,
							:sections, :recommendations
	
	# TO DO: 
	# 	1. Create proper association between item and ward

	def initialize(item_number, item)
		@item            = item

		@number          = item_number
		@item_type_id    = find_item_type_id
		@ward            = find_ward
		@title           = find_item_title
		@sections        = hash_sections(raw_html)
		@sections[:ward] = @ward

		@item 					 = nil
	end

	def to_h
		{
			number:       @number,
			item_type_id: @item_type_id,
			title:        @title,
			sections:     @sections,
		}
	end

	private
	attr_reader :item
	def find_item_type_id
		type = item.xpath("//table[@class='border']/tr/td/p/font").first.text.capitalize.chop
		ItemType.where("name = ?", type).first.id
	end

	def find_ward
		item.xpath("//table[@class='border']/tr/td/p/font")
				.last
				.text
				.chop
				.sub("Ward:", "")
				.split(", ")
				.map { |i| i.to_i unless i == "All"; i }
	end

	def find_item_title
		item.xpath('//table/tr/td/font/b').first.text
	end

	def raw_html
		item_tables = item.xpath('//table')
		item.xpath('//table')[2..item_tables.length]
	end

	def hash_sections(contents)

		sections = Hash.new('')
		current_section = ""

		contents.css('td').map do |node|
			if node.css('p').length > 0
				sections[current_section] << node.css('p')
																				 .map(&:text)
																				 .join(" ")
			elsif is_header?(node)
				current_section = node.text
				sections[current_section] = ""
			else
				content = node.to_s
				sections[current_section] << sanitize(content, tags: %w(p))
			end
		end.flatten
		sections
	end

	def is_header?(node)
		is_bold?(node) && !is_italic?(node) && match_keywords?(node)
	end

	def is_bold?(node)
		node.css('b').length > 0
	end

	def is_italic?(node)
		node.css('i').length > 0
	end

	def match_keywords?(node)
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

		keywords.any? { |keyword| node.text[keyword] }
	end

end