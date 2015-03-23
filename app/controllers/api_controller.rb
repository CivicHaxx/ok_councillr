class ApiController < ApplicationController
	before_action :change_query_order, only: :index

	@@order = :id

	def change_query_order
		unless params[:order] == nil
			@@order = params[:order].to_sym
		end
	end
end
