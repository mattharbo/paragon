class PlayersController < ApplicationController
  
  before_action :set_player, only: [:edit, :show, :update, :destroy]
  
  def index
    @players=Player.all.order("id desc")
  end

  def edit
  end

  def show 
    
    @player_contracts = Contract.where(player:@player)
    @latest_contract = Contract.where(player:@player).last
    all_player_selections = Selection.where(contract:Contract.where(player:@player))
    total_notes = 0
    number_notes = 0
    @stats_of_arrays=[]

    all_player_selections.each do |player_sel|

      if player_sel.note > 0
        number_notes+=1
        total_notes+=player_sel.note
      end

    end

    number_notes > 0 ? @average_note=(total_notes/number_notes).round(1) : @average_note="&#x1F937;"

    @player_contracts.each do |player_contract|

      # 🚧🚧🚧🚧🚧 Competseason added manually!!!! 😳 🚧🚧🚧🚧🚧

      number_of_team_games = team_fixtures_in_season(player_contract.team,Competseason.last).count

      player_selections = Selection.where(contract:player_contract)
      
      involved_games=0
      starter_games=0
      minutes_of_play=0

      player_contract_array = []

      player_selections.each do |player_selection|

        if player_selection.starter?
            involved_games+=1
            starter_games+=1

            # Did starter play entirely the game or not? (90mn vs. until replacement)
            if player_selection.substitutiontime.nil?
              minutes_of_play+=90
            else
              minutes_of_play+=player_selection.substitutiontime          
            end
        elsif !player_selection.substitutiontime.nil? and player_selection.substitutiontime > 0
            involved_games+=1
            minutes_of_play+=(90-player_selection.substitutiontime) 
        end

        if involved_games > 0 
          pourcentage_of_games_started_when_involved=(starter_games/involved_games)*100
        else
          pourcentage_of_games_started_when_involved=0
        end

        pourcentage_of_games_involved_for_the_team_this_season=(involved_games/number_of_team_games)*100

        player_contract_array = [
          number_of_team_games, 
          involved_games, 
          pourcentage_of_games_involved_for_the_team_this_season,
          pourcentage_of_games_started_when_involved,
          minutes_of_play]

        @stats_of_arrays << player_contract_array

      end
    end
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

  def team_fixtures_in_season(team,competseason)
    # Total number of games for a given team in a given season
    @team_season_games = Fixture.where(competseason:competseason).where(hometeam:team).or(Fixture.where(awayteam:team))
    return @team_season_games
  end

end
