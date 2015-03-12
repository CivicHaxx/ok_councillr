class Api::AgendasController < ApplicationController
	def index
		@agendas = Agenda.all

		render json: @agendas
	end

	def show
		@agenda = Agenda.find(params[:id])

		render json: @agenda
	end
end
