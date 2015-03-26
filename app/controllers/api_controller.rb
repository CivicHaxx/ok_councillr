class ApiController < ApplicationController
	before_action :add_querying, only: :index

	@@query = ""

	def add_querying
		@@query = (params[:q] == nil) ? "" : "%#{params[:q].downcase}%" 
	end

	def change_per_page
		(params[:per_page].to_i > 100) ? 100 : params[:per_page].to_i
	end

	def change_query_order
		if params[:order] == nil
			:id
		else
			orders = params[:order].split(",")

			orders.map! do |order|
				order_direction = order.strip.split(".")

				(order_direction.length == 1) ? order_direction[0].to_sym : "#{order_direction[0]} #{order_direction[1]}"
			end

			orders
		end
	end

	def search_by_date_range(date_from_url, model_search_throw, date_field_name)
		return model_search_throw unless date_from_url.present?

		dates = set_date_format(date_from_url.split(","))
		
		if dates.length > 1
      model_search_throw.where("#{date_field_name} >= ? AND #{date_field_name} < ?", dates[0], dates[1])
    else
      model_search_throw.where("#{date_field_name} = ?", dates[0])
    end
	end

	private
	def set_date_format(dates)
		dates.map { |date| Date.strptime(date, '%m-%d-%Y') }
	end
end
