class ApiController < ApplicationController
	before_action :change_query_order, only: :index

	@@order = :id

	def change_query_order
		unless params[:order] == nil
			order_direction = params[:order].split(".")

			@@order = (order_direction.length == 1) ? order_direction[0].to_sym : "#{order_direction[0]} #{order_direction[1]}"
		end
	end
end
