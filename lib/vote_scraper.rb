# encoding: utf-8
require "http"
require "awesome_print"
require "colored"
require "csv"
require "pry"
require "nokogiri"
require "open-uri"
require "active_support/all"
require "active_record"


def post(params)
  HTTP.with_headers("User-Agent" => "INTERNET EXPLORER").post(url, form: params).body.to_s
end

def url
  URI("http://app.toronto.ca/tmmis/getAdminReport.do")
end

def report_download_params(term_id, member_id)
    {
      toDate: "",
      termId: term_id,
      sortOrder: "",
      sortBy: "",
      page: 0,
      memberId: member_id,
      itemsPerPage: 50,
      function: "getMemberVoteReport",
      fromDate: "",
      exportPublishReportId: 2,
      download: "csv",
      decisionBodyId: 0
    }
end

def term_page(id)
  term_url = "http://app.toronto.ca/tmmis/getAdminReport.do" +
             "?function=prepareMemberVoteReport&termId="
  Nokogiri::HTML(HTTP.get(term_url + id.to_s).body.to_s)
end

def get_members(term_id)
  term_page(term_id).css("select[name='memberId'] option")
                    .map{|x| { id: x.attr("value"), name: x.text } }
end

def deep_clean(string)
  string.scrub.encode('UTF-8', { invalid: :replace, undef: :replace, replace: '�'})
end

def run
  term_ids = [6]

  term_ids.each do |term_id|
    puts "Getting term #{term_id}"

    get_members(term_id)[1..-1].each do |member|
      puts "\nGetting member vote report for #{member[:name]}"

      params = report_download_params(term_id, member[:id])
      
      csv = post(params)
      csv = deep_clean(csv)
      
      # TO DO: Split CSV.parse into a method
      #    save each record csv in dir and then cyclcing over
      CSV.parse(csv, headers: true,
        header_converters: lambda { |h| h.try(:parameterize).try(:underscore) })
        .map{|x| x.to_hash.symbolize_keys }
        .map{|x| x.merge(councillor_id: member[:id], councillor_name: member[:name]) }
        .each do |x|
          begin
            RawVoteRecord.create!(x)
            print "|".blue
          rescue Encoding::UndefinedConversionError
            record = Hash[x.map {|k, v| [k.to_sym, v] }]
            RawVoteRecord.create!(record)
            print "|".red
          end
        end 
    end
  end

end

# results.first.map{x| [x[:date_time].to_time, x[:date_time]] }
binding.pry

puts ""