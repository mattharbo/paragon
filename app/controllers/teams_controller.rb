class TeamsController < ApplicationController

    before_action :set_team, only: [:show]

    def index
        @teams=Team.all.order("id ASC")
    end

    def show

        # A CHANGER CAR NE SONT PAS COMPTABILISER LES AUTO GOAL 
        # @games_goals=Event.where(eventtype:Eventtype.where("description like ?", "%Goal%")).or(Event.where(eventtype:Eventtype.where("description like ?", "%Penalty%"))).where(selection:Selection.where(contract:Contract.where(team:Team.find(params[:id]))))
        
    end

    private 

    def set_team
        @team=Team.find(params[:id])
    end

end
