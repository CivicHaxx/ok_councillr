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
end
