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
    total_notes = number_notes = @distinct_role_tot = 0
    @stats_of_arrays=[]

    all_player_selections.each do |player_sel|
      if !player_sel.note.nil? and player_sel.note > 0
        number_notes+=1
        total_notes+=player_sel.note
      end
    end

    number_notes > 0 ? @average_note=(total_notes/number_notes).round(1) : @average_note='🙅🏻‍♂️'

    @all_player_roles = {
      GK: {total: 0, top:5, left:225},
      LWB: {total: 0, top:100, left:400},
      LB: {total: 0, top:80, left:290},
      CB: {total: 0, top:80, left:225},
      RB: {total: 0, top:80, left:160},
      RWB: {total: 0, top:100, left:50},
      LDM: {total: 0, top:140, left:290},
      DM: {total: 0, top:140, left:225},
      RDM: {total: 0, top:140, left:160},
      LW: {total: 0, top:230, left:400},
      LM: {total: 0, top:210, left:300},
      CM: {total: 0, top:180, left:225},
      RM: {total: 0, top:210, left:150},
      RW: {total: 0, top:230, left:50},
      AM: {total: 0, top:240, left:225},
      LS: {total: 0, top:280, left:320},
      CF: {total: 0, top:280, left:225},
      RS: {total: 0, top:280, left:130},
      ST: {total: 0, top:320, left:225}
    }

    @player_contracts.each do |player_contract|

      # 🚧🚧🚧🚧🚧 Competseason added manually!!!! 😳🚧🚧🚧🚧🚧

      number_of_team_games = team_fixtures_in_season(player_contract.team,Competseason.last).count

      # Retrieve all selections of the player with a given contract
      player_selections = Selection.where(contract:player_contract) # 😳🚧🚧 Should be player's selection within a season! => group_by season is needed here
      
      involved_games = starter_games = minutes_of_play = 0

      @player_contract_array = []

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

          # Mise à jour du hash qui comptabilise toutes les positions du joueur 
          # d'après un scanne de toutes les "selections" sous tous ses "contracts"
          
          # 1. Récupération de la position par rapport à la selection dans laquelle on est => easy! .grid_pos
          player_position = player_selection.grid_pos

          # 2. Récupération de la formation de la team
          team_fixture_formation = get_formation(player_selection)

          # 3. Récupération du role du joeur dans le "fixture"
          player_fixture_role = player_role(player_position,team_fixture_formation)

          # 4. Mise à jour du hash qui cumule toutes les positions occupées en tant que titulaire par le joueur
          # prenant en paramètre les informations récupérées en 3.
          role_counter(@all_player_roles,player_fixture_role)

        elsif !player_selection.substitutiontime.nil? and player_selection.substitutiontime > 0
          involved_games+=1
          minutes_of_play+=(90-player_selection.substitutiontime) 
        end

      end ## end of each player_selections

      if involved_games > 0 
        pourcentage_of_games_started_when_involved=(starter_games/involved_games)*100
        average_minutes_by_appearance = minutes_of_play/involved_games
      else
        pourcentage_of_games_started_when_involved = 0
        average_minutes_by_appearance = 0
      end

      pourcentage_of_games_involved_for_the_team_this_season = ((involved_games.to_f/number_of_team_games.to_f)*100).round(2)

      @player_contract_array = [
        number_of_team_games, 
        involved_games, 
        pourcentage_of_games_involved_for_the_team_this_season,
        pourcentage_of_games_started_when_involved,
        average_minutes_by_appearance]

      @stats_of_arrays << @player_contract_array

    end ## end of each player_contracts


    @all_player_roles.each do |distinct_role|
      @distinct_role_tot+=distinct_role[1][:total]
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
    @team_season_games =Fixture.where(competseason:competseason).and(Fixture.where(awayteam:team).or(Fixture.where(hometeam:team)))
    return @team_season_games
  end

  def player_role(position,formation)

    case position
    when "1:1"
      @playerrole = :GK
    when "2:1"
      formation.chr == "3" ? @playerrole = :LB : @playerrole = :LWB
    when "2:2"
      formation.chr == "3" ? @playerrole = :CB : @playerrole = :LB
    when "2:3"
      formation.chr == "5" ? @playerrole = :CB : @playerrole = :RB
    when "2:4"
      if formation.chr == "4"
        @playerrole = :RWB
      elsif formation.chr == "5"
        @playerrole = :RB
      end
    when "2:5"
      if formation == "5-4-1"
        @playerrole = :RWB
      end
    when "3:1"
      if formation[2] == "4"
        @playerrole = :LW
      else
        if formation == "4-3-3"
          @playerrole = :LM
        elsif formation == "4-2-3-1"
          @playerrole = :LDM
        elsif formation == "4-1-4-1"
          @playerrole = :DM
        end
      end
    when "3:2"
      if formation[2] == "4"
        @playerrole = :LM
      else
        if formation == "4-3-3"
          @playerrole = :CM
        elsif formation == "4-2-3-1"
          @playerrole = :RDM
        end
      end
    when "3:3"
      if formation[2] == "4" or formation[2] == "3"
        @playerrole = :RM
      end
    when "3:4"
      if formation[2] == "4"
        @playerrole = :RW
      end
    when "4:1"
      if formation == "4-4-2" or formation == "4-3-3" or formation == "3-4-2-1" or formation == "3-4-3"
        @playerrole = :LS
      else
        if formation == "5-4-1" or formation == "3-4-1-2"
          @playerrole = :CF
        elsif formation == "4-2-3-1"
          @playerrole = :LM
        elsif formation == "4-1-4-1"
          @playerrole = :LW
        end
      end
    when "4:2"
      if formation[-1] == "3"
        @playerrole = :CF
      elsif formation == "4-4-2" or formation == "3-4-2-1"
        @playerrole = :RS
      elsif formation == "4-2-3-1" or formation == "4-1-4-1"
        @playerrole = :AM 
      end
    when "4:3"
      if formation[-1] == "3"
        @playerrole = :RS
      elsif formation == "4-2-3-1"
        @playerrole = :RM
      elsif formation == "4-1-4-1"
        @playerrole = :AM
      end
    when "4:4"
      if formation == "4-1-4-1"
        @playerrole = :RW
      end
    when "5:1"
      if formation == "4-2-3-1" or formation == "3-4-2-1" or formation == "4-1-4-1"
        @playerrole = :ST
      elsif formation == "3-4-1-2"
        @playerrole = :LS
      end
    when "5:2"
      if formation == "3-4-1-2"
        @playerrole = :RS
      end
    end #-- of case/when
      
    return @playerrole
  end

  def role_counter(thehash,role)
    thehash[role][:total]+=1
    return thehash
  end

  def get_formation(theselection)
    # 2.1 > Récupérer la "team" du joueur lors de la selection (en passant par le "contract")
    playerteam = theselection.contract.team
    # 2.2 > Par ailleurs vérifier si la "team" est "home" ou "away" dans le "fixture" de la selection
    # 2.3 > En fonction de 2.2 alors récupérer la "formation" depuis la "fixture"
    theselection.fixture
    if theselection.fixture.hometeam == playerteam
      return formation = theselection.fixture.homeformation
    else
      return formation = theselection.fixture.awayformation
    end
  end

end
