# encoding: utf-8
require "net/http"
require "awesome_print"
require "colored"
require "csv"
require "pry"
require "nokogiri"
require "open-uri"
require "active_support/all"
require "active_record"

require_relative "./db_setup.rb"
require_relative "./db/migrations/001_create_vote_records_table.rb"

configuration = YAML::load(IO.read("config/database.yml"))
ActiveRecord::Base.establish_connection(configuration["development"])


class VoteRecord < ActiveRecord::Base
end

def migrate
  CreateVoteRecordsTable.migrate(:change)
end

def run
  base     = URI("http://app.toronto.ca/tmmis/getAdminReport.do")
  term_url = "http://app.toronto.ca/tmmis/getAdminReport.do" +
             "?function=prepareMemberVoteReport&termId="
  term_ids = [3,4,6]

  term_ids.each do |term_id|
    puts "Getting term #{term_id}"

    term_page = Nokogiri::HTML(open(term_url + term_id.to_s))
    members   = term_page.css("select[name='memberId'] option")
                         .map{|x| { id: x.attr("value"), name: x.text } }

    members[1..-1].each do |member|
      puts "\nGetting member vote report for #{member[:name]}"

      params = report_download_params(term_id, member[:id])
      
      csv = Net::HTTP.post_form(base, params).body
      
      # TO DO: Split CSV.parse into a method
      #    save each record csv in dir and then cyclcing over
      CSV.parse(csv.scrub,
                headers: true,
                header_converters: lambda { |h| h.try(:parameterize).try(:underscore) })
        .map{|x| x.to_hash.symbolize_keys }
        .map{|x| x.merge(councillor_id: member[:id], councillor_name: member[:name]) }
        .each do |x|
          begin
            VoteRecord.create!(x)
            print "|".blue
          rescue Encoding::UndefinedConversionError
            record = Hash[x.map {|k, v| [k.to_sym, v.force_encoding('utf-8').scrub('')] }]
            RawVoteRecord.create!(record)
            print "|".red
          end
        end 
    end
  end

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

# results.first.map{x| [x[:date_time].to_time, x[:date_time]] }
binding.pry

puts ""