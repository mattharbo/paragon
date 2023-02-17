class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy]

  def index
    @events=Event.all.order("id asc")
  end

  def edit

    if @event.selection.contract.team=@event.selection.fixture.hometeam
      @primcolor=Kit.where(team:@event.selection.contract.team).where(season:@event.selection.fixture.competseason.season).take.home_primary_color
      @secondcolor=Kit.where(team:@event.selection.contract.team).where(season:@event.selection.fixture.competseason.season).take.home_secondary_color
    else
      @primcolor=Kit.where(team:@event.selection.contract.team).where(season:@event.selection.fixture.competseason.season).take.away_primary_color
      @secondcolor=Kit.where(team:@event.selection.  contract.team).where(season:@event.selection.fixture.competseason.season).take.away_secondary_color
    end

  end

  def update

    # penalty             = 1100cm <> 85px
    # distance recherchée = ???m <> b
    a=((params['event']['ypitchcoord'].to_f)/100)*343
    c=((438/2)-(((params['event']['xpitchcoord'].to_f)/100)*438)).abs()
    b=Math.sqrt((a*a+c*c)) # My good old Pythagoras friend :)
    distance=((b*1100)/85/100).round(1)

    # Following to be updated with date retrieve from the front
    @event.xpitchcoord=params['event']['xpitchcoord'].to_f
    @event.ypitchcoord=params['event']['ypitchcoord'].to_f
    @event.xcagecoord=params['event']['xcagecoord'].to_f
    @event.ycagecoord=params['event']['ycagecoord'].to_f
    @event.distance=distance
    @event.save

# ----------------------------------------
# a tester car ne fonctionne pas en prod…

# 1ere OPTION

# faire requete unique d'update => .update avec les elements en params

# 2nd OPTION

# avant cela il faut mettre à jour params[] avec (xpitch, ypitch, xcage, ycage,) distance

# @event.update(event_params)

# ----------------------------------------



    # Redirection vers le form pour l'ajout de tag(s)
    redirect_to new_event_eventtag_path(params['id'])
    
  end

  def destroy
    
  end

  def registered
    @registered_events=Event.where(registration: true).last(50).reverse
  end

  def unregistered
    @unregistered_events=Event.where(registration: [nil, false])
  end

  private
  
  def set_event
    @event=Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:xpitchcoord, :ypitchcoord, :xcagecoord, :ycagecoord, :distance, :registration, :goalrank)
  end

end
