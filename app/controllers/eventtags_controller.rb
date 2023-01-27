class EventtagsController < ApplicationController
	before_action :set_event, only: [:new, :update]

	def new
		@eventtag = Eventtag.new
	end

	def create
	end

	private
  
	def set_event
	@event=Event.find(params[:event_id])
	end

	def eventtag_params
	# params.require(:player).permit(:xpitchcoord, :ypitchcoord, :xcagecoord, :ycagecoord, :distance, :registration, :goalrank)
	end
end
