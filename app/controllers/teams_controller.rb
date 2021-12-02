class TeamsController < ApplicationController

    def index
        @teams=Team.all.order("id ASC")
    end

end
