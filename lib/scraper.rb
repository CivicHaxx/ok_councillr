require 'active_record'
require 'active_support/all'
require 'action_view/helpers'
require 'awesome_print'
require 'colored'
require 'csv'
require 'http'
require 'nokogiri'
require 'open-uri'

class Scraper

	def initialize
		@base_uri = "http://app.toronto.ca/tmmis/"
	end

	def post(url, params)
    HTTP.with_headers("User-Agent" => "INTERNET EXPLORER")
    .post(url, form: params)
    .body
    .to_s
  end
  
  def save(name, content)
    File.open(filename(name), 'w') { |f| f.write (content) }
  end
 
	def raw_dir(doc_type)
		case doc_type
		when "agendas" then "lib/dirty_agendas"
		when "votes"	 then "lib/vote_records"
		end
	end
end