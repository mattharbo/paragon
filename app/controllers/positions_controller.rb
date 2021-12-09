class PositionsController < ApplicationController
  def index
    @positions=Position.all.order("id asc")
  end
end
