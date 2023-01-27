class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy]

  def index
    @events=Event.all.order("id asc")
  end

  def edit
  end

  def update
    
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
    params.require(:player).permit(:xpitchcoord, :ypitchcoord, :xcagecoord, :ycagecoord, :distance, :registration, :goalrank)
  end

end
