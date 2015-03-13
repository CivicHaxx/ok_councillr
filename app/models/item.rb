class Item < ActiveRecord::Base
	belongs_to :item_type
	belongs_to :agenda

	has_many :user_votes

	def self.construct(item_number, item)
		Item.new.tap do |agenda|
			agenda.construct(item_number, item)
		end
	end

	def construct(item_number, item)
		@item            = item

		@number          = item_number
		@type            = find_item_type
		@ward            = find_ward
		@title           = find_item_title
		@sections        = hash_sections(raw_html)
		@recommendations = @sections[:recommendations]

		@item = nil
	end

	def to_s
		[
			"Number: #{@number}",
			"Title: #{@title}",
			"Ward: #{@ward}",
			"Type: #{@type}",
			"-------",
			@contents.join("\n")
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
				sections[current_section] << node.to_s
			end
		end.flatten
		sections
	end
end
