class TeamsController < ApplicationController

    before_action :set_team, only: [:show]

    def index
        @teams=Team.all.order("id ASC")
    end

    def show

        # @home_games_goals=Event.where(selection:Selection.where(fixture:Fixture.where(hometeam:Team.find(params[:id]))))
        # @away_games_goals=Event.where(selection:Selection.where(fixture:Fixture.where(awayteam:Team.find(params[:id]))))

        @games_goals=Event.where(selection:Selection.where(contract:Contract.where(team:Team.find(params[:id]))))
        
    end

    private 

    def set_team
        @team=Team.find(params[:id])
    end

end
