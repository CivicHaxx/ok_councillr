module Scraper

	def post(url, params)
    HTTP.with_headers("User-Agent" => "INTERNET EXPLORER")
    .post("http://app.toronto.ca/tmmis/#{url}", form: params)
    .body
    .to_s
  end
  
  def get(url)
    HTTP.with_headers("User-Agent" => "INTERNET EXPLORER")
    .get(url)
  end
  
  def save(file_name, content)
    File.open(file_name, 'w') { |f| f.write (content) }
  end
 
	def raw_file_dir(doc_type)
		case doc_type
		when "agendas" then "lib/dirty_agendas"
		when "votes"	 then "lib/vote_records"
		end
	end

end