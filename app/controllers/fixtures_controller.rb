class FixturesController < ApplicationController

  before_action :set_fixture, only: [:show, :edit, :update, :destroy]

  def index
    @fixtures=Fixture.all.order("round DESC, date DESC")
    # @fixtures=Fixture.all.order("round ASC, date ASC")
  end

  def show
    @fixture_goals = Event.where(selection:Selection.where(fixture:Fixture.find(params[:id]))).order("created_at ASC")

    # fixture_goals.each do |goal|

    #   if goal.selection.contract.team == @fixture.hometeam

    #   elsif goal.selection.contract.team == @fixture.hometeam
        
    #   end

    # end


    fixtureselections=Selection.where(fixture:params[:id]).where(starter: true).order("selections.position_id ASC")

    @homeselection={}
    @awayselection={}

    if !fixtureselections.empty?
      retrieve_players(fixtureselections,@homeselection,@awayselection)
    end
  end

  private 

  def set_fixture
    @fixture=Fixture.find(params[:id])
  end

  def retrieve_players(sel,outputhome,outputaway)

    hometeam=sel.first.fixture.hometeam
    awayteam=sel.first.fixture.awayteam

    indexhome=indexaway=0

    sel.each do |player|

      case player.contract.team.id
      when hometeam.id
        indexhome+=1
        outputhome.store(indexhome,player)
      when awayteam.id
        indexaway+=1
        outputaway.store(indexaway,player)
      end
    
    end
  end

end
