class CompetseasonsController < ApplicationController
  def index
    @exercices=Competseason.all
  end
end
