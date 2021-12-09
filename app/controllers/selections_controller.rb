class SelectionsController < ApplicationController
  def index
    @selections=Selection.all.order("id ASC")
  end
end
