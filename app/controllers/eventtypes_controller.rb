class EventtypesController < ApplicationController

	def index
    	@eventtypes=Eventtype.all.order("id asc")
  	end
end
