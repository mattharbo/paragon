class SelectionsController < ApplicationController
  def index
    @selections=Selection.all
  end
end
