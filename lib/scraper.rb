module Scraper

	def post(url, params)
    HTTP.with_headers("User-Agent" => "INTERNET EXPLORER")
    .post("http://app.toronto.ca/tmmis/#{url}", form: params)
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