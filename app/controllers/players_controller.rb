class PlayersController < ApplicationController
  
  before_action :set_player, only: [:edit, :show, :update, :destroy]
  
  def index
    @players=Player.all.order("id desc")
  end

  def edit
  end

  def show 
    @player_contracts = Contract.where(player:@player)
  end

  def update
    player = @player.update(player_params)
	  redirect_to vip_players_path
  end

  def destroy
    @player.destroy
    redirect_to vip_players_path
  end

  private
  
  def set_player
    @player=Player.find(params[:id])
  end

  def player_params
	  params.require(:player).permit(:name, :firstname, :playerapiref)
  end
end
