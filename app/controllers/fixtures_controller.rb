class FixturesController < ApplicationController

  before_action :set_fixture, only: [:show, :edit, :update, :destroy]

  def index
    @fixtures=Fixture.all.order("round ASC")
  end

  def show
    @fixtureselections=Selection.where(fixture:params[:id]).where(starter: true)

    hometeam=Fixture.find(params[:id]).hometeam
    awayteam=Fixture.find(params[:id]).awayteam

    @homeselection={}
    @awayselection={}
    indexhome=indexaway=0

    @fixtureselections.each do |fixtureselection|

      case fixtureselection.contract.team.id
      when hometeam.id
        indexhome+=1
        @homeselection.store(indexhome,fixtureselection)
      when awayteam.id
        indexaway+=1
        @awayselection.store(indexaway,fixtureselection)
      end
    
    end
  end

  private 

  def set_fixture
    @fixture=Fixture.find(params[:id])
  end

end
