class KitsController < ApplicationController

	before_action :set_kit, only: [:edit, :update]

	def edit
	end

	def update
	    kit = @kit.update(kit_params)
		redirect_to vip_kits_path
	end

	private
  
	def set_kit
		@kit=Kit.find(params[:id])
	end

	def kit_params
	  params.require(:kit).permit(:home_primary_color, :home_secondary_color, :away_primary_color, :away_secondary_color, :third_primary_color, :third_secondary_color)
  	end

end
