class FixturesController < ApplicationController

  # To by-pass Devise authentication on some specific actions
  skip_before_action :authenticate_user!, only: [:show, :destroy]
  before_action :set_fixture, only: [:show, :edit, :update, :destroy]

  def index
    @fixtures=Fixture.all.order("round DESC, date DESC")
    # @fixtures=Fixture.all.order("round ASC, date ASC")
  end

  def show
    @fixture_goals = Event.where(selection:Selection.where(fixture:Fixture.find(params[:id]))).order("created_at ASC")

    # --------------------------
    # UNDER DEVELOPEMENT

    # Pour chaque joueur il faut mettre dans un hash pour exploitation par le front-end :
    # - le numéro
    # - le nom
    # - la couleur de la note
    # - la note
    # - le nombre de but
    # - la minute de remplacement
    # - le numéro du joeur qui entre en jeu
    
    # Récupération des teams id home & away
    hometeamid = Fixture.find(params[:id]).hometeam.id
    awayteamid = Fixture.find(params[:id]).awayteam.id

    # Récupération de toutes selections des starters de la fixture pour les deux teams
    starters=Selection.where(fixture:params[:id]).where(starter: true)

    # Récupération de toutes selections des remplaçants de la fixture pour la team away
    substitutes=Selection.where(fixture:params[:id]).where(starter: false)

    @one = retrieve_note_color(9.1)
    @two = retrieve_note_color(8.1)
    @three = retrieve_note_color(7.1)
    @four = retrieve_note_color(6.6)
    @five = retrieve_note_color(6.1)
    @six = retrieve_note_color(5.4)

    # raise

    # --------------------------

    fixtureselections=Selection.where(fixture:params[:id]).where(starter: true).order("selections.position_id ASC")

    @homeselection={}
    @awayselection={}

    if !fixtureselections.empty?
      retrieve_players(fixtureselections,@homeselection,@awayselection)
    end
  end

  def destroy
    fixtodestroy = Fixture.find(params[:id])
    fixtodestroy.destroy
    redirect_to vip_fixtures_path
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

  def retrieve_note_color(note)
    if note >= 9
      return "#00A19F"
    elsif note >= 8.0 && note <= 8.9
      return "#2FB700"
    elsif note >= 7.0 && note <= 7.9
      return "#B1D80E"
    elsif note >= 6.5 && note <= 6.9
      return "#FFB800"
    elsif note >= 6.0 && note <= 6.4
      return "#FF7100"
    else note <= 5.9
      return "#FF0004"
    end
  end

end
