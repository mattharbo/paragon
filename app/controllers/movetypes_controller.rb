class MovetypesController < ApplicationController
	before_action :set_movetype, only: [:edit, :update, :destroy]

	def index
		@movetypes=Movetype.all
	end

	def new
		@movetype=Movetype.new
	end

	def create
		Movetype.create(movetype_params)
		redirect_to vip_movetypes_path
	end

	def edit
	end

	def update
		movetype = @movetype.update(movetype_params)
		redirect_to vip_movetypes_path
	end

	def destroy
		@movetype.destroy
	    redirect_to vip_movetypes_path
	end

	private

	def set_movetype
		@movetype=Movetype.find(params[:id])
	end

	def movetype_params
		params.require(:movetype).permit(:description)
	end

end
