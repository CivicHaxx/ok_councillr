class VoteScraper
  include Scraper

  def initialize(term_id, from_date, to_date)
    @term_id      = term_id
    @raw_file_dir = "#{raw_file_dir("votes")}/"
    @url          = "getAdminReport.do"
    @from_date    = from_date
    @to_date      = to_date
    @member_emoji = %w(😀 😁 😂 😃 😄 😅 😆 😇 😈)
    @members      = get_members(@term_id)
  end

  def run
    puts "Getting member vote reports"
    @members[1..-1].each do |member|
      member_name = camel_case_name(member)
      unless File.exist? "#{@raw_file_dir}/#{member_name}.csv"
        get_vote_record(member)
      end
      puts "\nParsing vote record for #{member[:name]} 💚 "
      parse_vote_record(member)
    end
  end

  def get_vote_record(member)
      puts "#{member[:name]} #{@member_emoji.sample}"
      params    = report_download_params(@term_id, member[:id])
      csv       = post(@url, params)
      csv       = deep_clean(csv)
      save(file_name(member), csv)
  end
  
  def parse_vote_record(member)
    csv = File.open(file_name(member), 'r')
    CSV.parse(csv, headers: true,
      header_converters: lambda { |h| h.try(:parameterize).try(:underscore) })
      .map{|x| x.to_hash.symbolize_keys }
      .map{|x| x.merge(councillor_id: member[:id], councillor_name: member[:name]) }
      .each do |x|
        begin
          RawVoteRecord.create!(x)
        rescue Encoding::UndefinedConversionError
          record = Hash[x.map {|k, v| [k.to_sym, v] }]
          RawVoteRecord.create!(record)
          print " 💔 "
        end
      end 
  end

  private

  def get_members(term_id)
    get_term_page(term_id).css("select[name='memberId'] option")
                          .map{|x| { id: x.attr("value"), name: x.text } }
  end

  def get_term_page(id)
    Nokogiri::HTML(post(@url, term_page_params(@term_id)))
  end


  def file_name(member)
    @raw_file_dir + camel_case_name(member) + ".csv"
  end

  def camel_case_name(member)
    member[:name].downcase.gsub( " ", "_" ).to_s
  end

  def term_page_params(term_id) #getAdminReport.do
    {
      function: 'prepareMemberVoteReport',
      download: "N",
      exportPublishReportID: "2",
      termId: term_id,
      memberId: "0",
      fromDate: "",
      toDate: ""
    }
  end

  def report_download_params(term_id, member_id)
      {
        function: "getMemberVoteReport",
        download: "csv",
        page: 0,
        itemsPerPage: 50,
        sortBy: "",
        sortOrder: "",
        exportPublishReportId: 2,
        termId: term_id,
        memberId: member_id,
        # TO DO: scrape decision body ids with councillor ids
        # city council for last term is 261, for all committees, 0
        # for current term 961. why?
        decisionBodyId: 261, 
        fromDate: @from_date,
        toDate: @to_date
      }
  end

end