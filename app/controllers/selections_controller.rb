class SelectionsController < ApplicationController
  def index
    @selections=Selection.all.order("id ASC")
    # @selections=Selection.includes(:fixture).all.order("fixtures.scorehome ASC")
  end
end
