class Api::CouncillorsController < ApiController
  def index
    date = params[:date]
    ward_id = params[:ward_id]
    councillor_name = params[:councillor_name]
    @councillors = Councillor.all

    @councillors = @councillors.where("lower(first_name) LIKE ? OR 
        lower(last_name) LIKE ? OR 
        lower(email) LIKE ?", @@query, @@query, @@query) unless @@query.empty?
    @councillors = @councillors.where("ward_id = ?", ward_id) if ward_id.present?

    if date.present?
      dates = date.split(",")

      @councillors = if dates.length > 1
        @councillors.where("start_date_in_office >= ? AND start_date_in_office < ?", Date.strptime(dates[0], '%m-%d-%Y'), Date.strptime(dates[1], '%m-%d-%Y'))
      else
        @councillors.where("start_date_in_office = ?", Date.strptime(dates[0], '%m-%d-%Y'))
      end
    end

    if councillor_name.present?
      councillor_name = councillor_name.downcase

		  @councillors = @councillors.where("lower(first_name) = ? OR lower(last_name) = ? OR lower(first_name) || ' ' || lower(last_name) = ?", councillor_name, councillor_name, councillor_name)
    end

  	paginate json: @councillors.order(change_query_order), per_page: change_per_page
  end

  def show
  	@councillor = Councillor.find(params[:id])

		render json: @councillor, serializer: CouncillorDetailSerializer
  end
end
