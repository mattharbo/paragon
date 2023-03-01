class MovesController < ApplicationController

	before_action :set_move, only: [:edit]
	before_action :set_event, only: [:new]

	def index
		@moves=Move.all.order("id asc")
	end

	def new

		# Retrieve kit colors for display
		retrievekitscolors()

		# Retrieve all attributes of the associated @event
		# ==> already in set_event

		# Retrieve all moves already registered for the @event
		@moves=Move.where(event:@event)

		# Retrieve all players registered to the game
		allplayers=Selection.where(fixture:@event.selection.fixture)

		# Retrieve all moves types in BD
		@movetypes=Movetype.all

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

	def set_event
		@event=Event.find(params[:event_id])
	end

	def set_move
		@move=Move.find(params[:id])
	end

	def move_params
		params.require(:move).permit(:event, :movetype, :selection, :startxcoord, :startycoord, :endxcoord, :endycoord, :rank, :key)
	end

	def retrievekitscolors
		if @event.selection.contract.team=@event.selection.fixture.hometeam
	      @primcolor=Kit.where(team:@event.selection.contract.team).where(season:@event.selection.fixture.competseason.season).take.home_primary_color
	      @secondcolor=Kit.where(team:@event.selection.contract.team).where(season:@event.selection.fixture.competseason.season).take.home_secondary_color
	    else
	      @primcolor=Kit.where(team:@event.selection.contract.team).where(season:@event.selection.fixture.competseason.season).take.away_primary_color
	      @secondcolor=Kit.where(team:@event.selection.  contract.team).where(season:@event.selection.fixture.competseason.season).take.away_secondary_color
	    end
	end
end