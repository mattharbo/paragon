class SelectionsController < ApplicationController

  before_action :set_selection, only: [:update, :edit]
  
  def index
    # @selections=Selection.first(50)
    @selections=Selection.last(50).reverse
    # @selections=Selection.includes(:fixture).all.order("fixtures.scorehome ASC")
  end

  def update
    team = @selection.update(set_selection)
    redirect_to selections_path
  end

  def edit
    
  end

  private

  def set_selection
    @selection=Selection.find(params[:id])
  end

  def team_params
    params.require(:selection).permit(:starter, :substitutiontime, :note, :substitute_id, :position_id, :grid_pos)
  end

end
