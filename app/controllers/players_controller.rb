class PlayersController < ApplicationController
  
  before_action :set_player, only: [:edit, :update, :destroy]
  
  def index
    @players=Player.all.order("id asc")
  end

  def edit
  end

  def update
    player = @player.update(player_params)
	  redirect_to players_path 
  end

  def destroy
    @player.destroy
    redirect_to players_path
  end

  private
  
  def set_player
    @player=Player.find(params[:id])
  end

  def player_params
	  params.require(:player).permit(:name, :firstname, :playerapiref)
  end
end
