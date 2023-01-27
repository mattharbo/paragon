class MovesController < ApplicationController

	before_action :set_move, only: [:edit, :show, :update, :destroy]

	def index
		@moves=Move.all.order("id asc")
	end

	def new
		
	end

	def create
		
	end

	def edit
		
	end

	def update
		
	end

	def destroy
		
	end

	private

	def set_move
		@move=Move.find(params[:id])
	end

	def move_params
		params.require(:move).permit(:event, :movetype, :selection, :startxcoord, :startycoord, :endxcoord, :endycoord, :rank, :key)
	end
end