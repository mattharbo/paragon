class EventtagsController < ApplicationController
	before_action :set_event, only: [:new, :create, :update]

	def new
		@eventtag = Eventtag.new

		@alltagsindb=Tag.all
	end

	def create

		number=1
		while number < params['eventtag']['tag_id'].size
			Eventtag.create(event:@event,tag:Tag.find(params['eventtag']['tag_id'][number]))
			number+=1
		end

		redirect_to new_event_move_path(params['event_id'])

	end

	private
  
	def set_event
		@event=Event.find(params[:event_id])
	end

	def eventtag_params
	# params.require(:player).permit(:xpitchcoord, :ypitchcoord, :xcagecoord, :ycagecoord, :distance, :registration, :goalrank)
	end
end
