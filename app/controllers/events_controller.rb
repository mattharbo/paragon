class EventsController < ApplicationController
  def index
    @events=Event.all.order("id asc")
  end

  def registered
    @registered_events=Event.where(registration: true)
  end

  def unregistered
    @unregistered_events=Event.where(registration: [nil, false])
  end
end
