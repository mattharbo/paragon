class TeamsController < ApplicationController

    before_action :set_team, only: [:show, :update, :edit, :destroy]

    def index
        @teams=Team.all.order("id ASC")
    end

    def show

        # A CHANGER CAR NE SONT PAS COMPTABILISER LES AUTO GOAL 
        # @games_goals=Event.where(eventtype:Eventtype.where("description like ?", "%Goal%")).or(Event.where(eventtype:Eventtype.where("description like ?", "%Penalty%"))).where(selection:Selection.where(contract:Contract.where(team:Team.find(params[:id]))))

        @team_color = "#FFE2EB"
        
    end

    def edit
    end

    def update
        team = @team.update(team_params)
        redirect_to teams_path 
    end

    def destroy
        @team.destroy
        redirect_to teams_path
    end

    private 

    def set_team
        @team=Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name, :display_name, :shortname)
    end

end
