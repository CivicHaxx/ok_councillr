class VoteScraper
  include Scraper

  def initialize(term_id)
    @term_id      = term_id
    @raw_file_dir = "#{raw_file_dir("votes")}/"
    @url          = "getAdminReport.do"
  end

  def get_vote_record(member)
    member_emoji = %w(😀 😁 😂 😃 😄 😅 😆 😇 😈 )
      puts "Getting member vote report for #{member[:name]} #{member_emoji.sample}"
      
      params    = report_download_params(@term_id, member[:id])
      csv       = post(@url, params)
      csv       = deep_clean(csv)
      save(file_name(member), csv)
  end

  def file_name(member)
    @raw_file_dir + camel_case_name(member) + ".csv"
  end

  def camel_case_name(member)
    member[:name].downcase.gsub( " ", "_" ).to_s
  end

  def run
    get_members(@term_id)[1..-1].each do |member|
      member_name = camel_case_name(member)
      unless File.exist? "#{@raw_file_dir}/#{member_name}.csv"
        get_vote_record(member)
      end
    end
  end
  
  def parse
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
        decisionBodyId: 961 #city council, for all, 0
      }
  end

  def get_term_page(id)
    term_url = @url + "?function=prepareMemberVoteReport&termId="
    Nokogiri::HTML(get(term_url + id.to_s).body.to_s)
  end

  def get_members(term_id)
    get_term_page(term_id).css("select[name='memberId'] option")
                          .map{|x| { id: x.attr("value"), name: x.text } }
  end

  def deep_clean(string)
    string.scrub.encode('UTF-8', { invalid: :replace, undef: :replace, replace: '�'})
  end
end