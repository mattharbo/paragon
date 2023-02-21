class FixturesController < ApplicationController

  # To by-pass Devise authentication on some specific actions
  skip_before_action :authenticate_user!, only: [:show, :destroy]
  before_action :set_fixture, only: [:show, :edit, :update, :destroy, :fixturegoals]

  def index
    @fixtures=Fixture.all.order("round DESC, date DESC")
    # @fixtures=Fixture.all.order("round ASC, date ASC")
  end

  def show
    @fixture_goals = Event.where(selection:Selection.where(fixture:Fixture.find(params[:id]))).order("created_at ASC")
    
    # Récupération des teams id home & away
    hometeamid = Fixture.find(params[:id]).hometeam.id
    awayteamid = Fixture.find(params[:id]).awayteam.id

    # Récupération de toutes selections des starters de la fixture pour les deux teams
    @starters=Selection.where(fixture:params[:id]).where(starter: true)

    # Récupération de toutes selections des remplaçants de la fixture pour les deux teams
    substitutes=Selection.where(fixture:params[:id]).where(starter: false)

    # Récupération du kit utilisé pour la hometeam & la awayteam
    case @fixture.homekit
    when "home"
      hometeamprimarybg = Kit.where(team:@fixture.hometeam).take.home_primary_color
      hometeamsedondarybg = Kit.where(team:@fixture.hometeam).take.home_secondary_color
    when "away"
      hometeamprimarybg = Kit.where(team:@fixture.hometeam).take.away_primary_color
      hometeamsedondarybg = Kit.where(team:@fixture.hometeam).take.away_secondary_color
    when "third"
      hometeamprimarybg = Kit.where(team:@fixture.hometeam).take.third_primary_color
      hometeamsedondarybg = Kit.where(team:@fixture.hometeam).take.third_secondary_color
    end

    case @fixture.awaykit
    when "home"
      awayteamprimarybg = Kit.where(team:@fixture.awayteam).take.home_primary_color
      awayteamsedondarybg = Kit.where(team:@fixture.awayteam).take.home_secondary_color
    when "away"
      awayteamprimarybg = Kit.where(team:@fixture.awayteam).take.away_primary_color
      awayteamsedondarybg = Kit.where(team:@fixture.awayteam).take.away_secondary_color
    when "third"
      awayteamprimarybg = Kit.where(team:@fixture.awayteam).take.third_primary_color
      awayteamsedondarybg = Kit.where(team:@fixture.awayteam).take.third_secondary_color
    end

    @allstartingplayers = Hash.new { |hash, key| hash[key] = {} }
    
    $i = 0
    while $i < @starters.count do
      
      @allstartingplayers[$i][:sel] = @starters[$i].id

      case @starters[$i].contract.team.id
      when hometeamid
        @allstartingplayers[$i][:team] = "home"
        @allstartingplayers[$i][:numberbgprimarycolor] = hometeamprimarybg
        @allstartingplayers[$i][:numberbgsecondarycolor] = hometeamsedondarybg
      when awayteamid
        @allstartingplayers[$i][:team] = "away"
        @allstartingplayers[$i][:numberbgprimarycolor] = awayteamprimarybg
        @allstartingplayers[$i][:numberbgsecondarycolor] = awayteamsedondarybg
      end

      @allstartingplayers[$i][:pitchcoord] = get_fullpitch_coords(@allstartingplayers[$i][:team],@starters[$i].grid_pos)

      # To be deleled once the function is okay
      @allstartingplayers[$i][:position] = @starters[$i].grid_pos

      @allstartingplayers[$i][:number] = @starters[$i].contract.jerseynumber

      @allstartingplayers[$i][:name] = @starters[$i].contract.player.name
      @allstartingplayers[$i][:note] = @starters[$i].note
      @allstartingplayers[$i][:notecolor] = retrieve_note_color(@starters[$i].note)
      @allstartingplayers[$i][:goals] = Event.where(selection:@starters[$i]).count
      if !@starters[$i].substitute.nil? 
        @allstartingplayers[$i][:subtime] = @starters[$i].substitutiontime
        @allstartingplayers[$i][:playerin] = @starters[$i].substitute.jerseynumber
      end
      
      $i += 1 
    end

    fixtureselections=Selection.where(fixture:params[:id]).where(starter: true).order("selections.position_id ASC")

    @homeselection={}
    @awayselection={}

    if !fixtureselections.empty?
      retrieve_players(fixtureselections,@homeselection,@awayselection)
    end
  end

  def edit
    @homekitoptions=Kit.where(team:Team.find(@fixture.hometeam.id)).take
    @awaykitoptions=Kit.where(team:Team.find(@fixture.awayteam.id)).take
  end

  def update
    kit = @fixture.update(fixture_params)
    redirect_to vip_fixtures_path
  end

  def destroy
    fixtodestroy = Fixture.find(params[:id])
    fixtodestroy.destroy
    redirect_to vip_fixtures_path
  end

  def fixturegoals

    fixturesselections=Selection.where(fixture:@fixture)

    @fixturegoalevents=[]

    fixturesselections.each do |selec|

      if Event.where(selection:selec).count == 1
        @fixturegoalevents << Event.where(selection:selec)
      end
    end

  end

  private 

  def set_fixture
    @fixture=Fixture.find(params[:id])
  end

  def fixture_params
    params.require(:fixture).permit(
      :homeformation, 
      :awayformation,
      :homekit,
      :awaykit)
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

  def get_fullpitch_coords(side,playergridposition)
    
    homepitchcoordpositionformationmatrix = {
      '3-2-4-1': {'1:1': {top:10, left:160},
                '2:1': {top:85, left:300},
                '2:2': {top:85, left:160},
                '2:3': {top:85, left:20},
                '3:1': {top:150, left:90},
                '3:2': {top:150, left:230},
                '4:1': {top:220, left:320},
                '4:2': {top:230, left:220},
                '4:3': {top:230, left:96},
                '4:4': {top:220, left:0},
                '5:1': {top:280, left:160},
                },
      '3-4-3': {'1:1': {top:10, left:160},
                '2:1': {top:85, left:300},
                '2:2': {top:85, left:160},
                '2:3': {top:85, left:20},
                '3:1': {top:185, left:320},
                '3:2': {top:185, left:212},
                '3:3': {top:185, left:106},
                '3:4': {top:185, left:0},
                '4:1': {top:280, left:280},
                '4:2': {top:270, left:160},
                '4:3': {top:280, left:40}
                },
      '3-4-1-2': {'1:1': {top:10, left:160},
                '2:1': {top:85, left:300},
                '2:2': {top:85, left:160},
                '2:3': {top:85, left:20},
                '3:1': {top:175, left:320},
                '3:2': {top:175, left:212},
                '3:3': {top:175, left:106},
                '3:4': {top:175, left:0},
                '4:1': {top:240, left:160},
                '5:1': {top:280, left:240},
                '5:2': {top:280, left:80},
                },
      '3-4-2-1': {'1:1': {top:10, left:160},
                '2:1': {top:85, left:300},
                '2:2': {top:85, left:160},
                '2:3': {top:85, left:20},
                '3:1': {top:175, left:320},
                '3:2': {top:175, left:212},
                '3:3': {top:175, left:106},
                '3:4': {top:175, left:0},
                '4:1': {top:250, left:60},
                '4:2': {top:250, left:260},
                '5:1': {top:280, left:160},
                },
      '3-5-2': {'1:1': {top:10, left:160},
                '2:1': {top:85, left:300},
                '2:2': {top:85, left:160},
                '2:3': {top:85, left:20},
                '3:1': {top:190, left:320},
                '3:2': {top:180, left:240},
                '3:3': {top:170, left:160},
                '3:4': {top:180, left:80},
                '3:5': {top:190, left:0},
                '4:1': {top:270, left:220},
                '4:2': {top:270, left:100}
                },
      '4-1-4-1': {'1:1': {top:10, left:160},
                '2:1': {top:85, left:300},
                '2:2': {top:85, left:160},
                '2:3': {top:85, left:20},
                '2:4': {top:85, left:0},
                '3:1': {top:160, left:160},
                '4:1': {top:200, left:320},
                '4:2': {top:200, left:220},
                '4:3': {top:200, left:96},
                '4:4': {top:200, left:0},
                '5:1': {top:280, left:160},
                },
      '4-2-3-1': {'1:1': {top:10, left:160},
                '2:1': {top:85, left:320},
                '2:2': {top:85, left:212},
                '2:3': {top:85, left:106},
                '2:4': {top:85, left:0},
                '3:1': {top:155, left:90},
                '3:2': {top:155, left:230},
                '4:1': {top:220, left:300},
                '4:2': {top:200, left:160},
                '4:3': {top:220, left:20},
                '5:1': {top:270, left:160},
                },
      '4-3-1-2': {'1:1': {top:10, left:160},
                  '2:1': {top:85, left:320},
                  '2:2': {top:85, left:212},
                  '2:3': {top:85, left:106},
                  '2:4': {top:85, left:0},
                  '3:1': {top:170, left:280},
                  '3:2': {top:160, left:160},
                  '3:3': {top:170, left:40},
                  '4:1': {top:240, left:160},
                  '5:1': {top:270, left:240},
                  '5:2': {top:270, left:80},
                  },
      '4-3-3': {'1:1': {top:10, left:160},
                '2:1': {top:85, left:320},
                '2:2': {top:85, left:212},
                '2:3': {top:85, left:106},
                '2:4': {top:85, left:0},
                '3:1': {top:190, left:280},
                '3:2': {top:180, left:160},
                '3:3': {top:190, left:40},
                '4:1': {top:280, left:280},
                '4:2': {top:270, left:160},
                '4:3': {top:280, left:40},
                },
      '4-4-1-1': {'1:1': {top:10, left:160},
                '2:1': {top:85, left:320},
                '2:2': {top:85, left:212},
                '2:3': {top:85, left:106},
                '2:4': {top:85, left:0},
                '3:1': {top:185, left:320},
                '3:2': {top:175, left:232},
                '3:3': {top:175, left:86},
                '3:4': {top:185, left:0},
                '4:1': {top:210, left:160},
                '5:1': {top:280, left:160},
                },
      '4-4-2': {'1:1': {top:10, left:160},
                '2:1': {top:85, left:320},
                '2:2': {top:85, left:212},
                '2:3': {top:85, left:106},
                '2:4': {top:85, left:0},
                '3:1': {top:185, left:320},
                '3:2': {top:185, left:212},
                '3:3': {top:185, left:106},
                '3:4': {top:185, left:0},
                '4:1': {top:270, left:220},
                '4:2': {top:270, left:100},
                },
      '4-5-1': {'1:1': {top:10, left:160},
                '2:1': {top:85, left:320},
                '2:2': {top:85, left:212},
                '2:3': {top:85, left:106},
                '2:4': {top:85, left:0},
                '3:1': {top:190, left:320},
                '3:2': {top:180, left:240},
                '3:3': {top:170, left:160},
                '3:4': {top:180, left:80},
                '3:5': {top:190, left:0},
                '4:1': {top:210, left:160}
                },
      '5-3-2': {'1:1': {top:10, left:160},
                '2:1': {top:105, left:320},
                '2:2': {top:85, left:240},
                '2:3': {top:85, left:160},
                '2:4': {top:85, left:80},
                '2:5': {top:105, left:0},
                '3:1': {top:190, left:280},
                '3:2': {top:180, left:160},
                '3:3': {top:190, left:40},
                '4:1': {top:270, left:220},
                '4:2': {top:270, left:100}
                },
      '5-4-1': {'1:1': {top:10, left:160},
                '2:1': {top:105, left:320},
                '2:2': {top:85, left:240},
                '2:3': {top:85, left:160},
                '2:4': {top:85, left:80},
                '2:5': {top:105, left:0},
                '3:1': {top:210, left:320},
                '3:2': {top:190, left:220},
                '3:3': {top:190, left:96},
                '3:4': {top:210, left:0},
                '4:1': {top:270, left:160}
                },
    }

    awaypitchcoordpositionformationmatrix = {
      '4-2-3-1': {'1:1': {top:617, left:160},
                '2:1': {top:542, left:0},
                '2:2': {top:542, left:106},
                '2:3': {top:542, left:212},
                '2:4': {top:542, left:320},
                '3:1': {top:467, left:230},
                '3:2': {top:467, left:90},
                '4:1': {top:387, left:20},
                '4:2': {top:427, left:160},
                '4:3': {top:387, left:300},
                '5:1': {top:357, left:160},
                },
      '3-2-4-1': {'1:1': {top:617, left:160},
                '2:1': {top:542, left:20},
                '2:2': {top:542, left:160},
                '2:3': {top:542, left:300},
                '3:1': {top:477, left:230},
                '3:2': {top:477, left:90},
                '4:1': {top:407, left:0},
                '4:2': {top:397, left:96},
                '4:3': {top:397, left:220},
                '4:4': {top:407, left:320},
                '5:1': {top:367, left:160},
                },
      '3-4-3': {'1:1': {top:617, left:160},
                '2:1': {top:542, left:20},
                '2:2': {top:542, left:160},
                '2:3': {top:542, left:300},
                '3:1': {top:442, left:0},
                '3:2': {top:442, left:106},
                '3:3': {top:442, left:212},
                '3:4': {top:442, left:320},
                '4:1': {top:347, left:40},
                '4:2': {top:337, left:160},
                '4:3': {top:347, left:280}
                },
      '3-4-1-2': {'1:1': {top:617, left:160},
                '2:1': {top:542, left:20},
                '2:2': {top:542, left:160},
                '2:3': {top:542, left:300},
                '3:1': {top:452, left:0},
                '3:2': {top:452, left:106},
                '3:3': {top:452, left:212},
                '3:4': {top:452, left:320},
                '4:1': {top:387, left:160},
                '5:1': {top:347, left:80},
                '5:2': {top:347, left:240},
                },
      '3-4-2-1': {'1:1': {top:617, left:160},
                '2:1': {top:542, left:20},
                '2:2': {top:542, left:160},
                '2:3': {top:542, left:300},
                '3:1': {top:452, left:0},
                '3:2': {top:452, left:106},
                '3:3': {top:452, left:212},
                '3:4': {top:452, left:320},
                '4:1': {top:377, left:260},
                '4:2': {top:377, left:60},
                '5:1': {top:357, left:160},
                },
      '3-5-2': {'1:1': {top:617, left:160},
                '2:1': {top:542, left:20},
                '2:2': {top:542, left:160},
                '2:3': {top:542, left:300},
                '3:1': {top:447, left:0},
                '3:2': {top:457, left:80},
                '3:3': {top:467, left:160},
                '3:4': {top:457, left:240},
                '3:5': {top:447, left:320},
                '4:1': {top:367, left:100},
                '4:2': {top:367, left:220}
                },
      '4-1-4-1': {'1:1': {top:617, left:160},
                '2:1': {top:542, left:0},
                '2:2': {top:542, left:20},
                '2:3': {top:542, left:160},
                '2:4': {top:542, left:300},
                '3:1': {top:467, left:160},
                '4:1': {top:427, left:0},
                '4:2': {top:427, left:96},
                '4:3': {top:427, left:220},
                '4:4': {top:427, left:320},
                '5:1': {top:347, left:160},
                },
      '4-3-1-2': {'1:1': {top:617, left:160},
                  '2:1': {top:542, left:0},
                  '2:2': {top:542, left:106},
                  '2:3': {top:542, left:212},
                  '2:4': {top:542, left:320},
                  '3:1': {top:457, left:40},
                  '3:2': {top:467, left:160},
                  '3:3': {top:457, left:280},
                  '4:1': {top:527, left:160},
                  '5:1': {top:497, left:80},
                  '5:2': {top:497, left:240},
                  },
      '4-3-3': {'1:1': {top:617, left:160},
                '2:1': {top:542, left:0},
                '2:2': {top:542, left:106},
                '2:3': {top:542, left:212},
                '2:4': {top:542, left:320},
                '3:1': {top:437, left:40},
                '3:2': {top:447, left:160},
                '3:3': {top:437, left:280},
                '4:1': {top:347, left:40},
                '4:2': {top:357, left:160},
                '4:3': {top:347, left:280},
                },
      '4-4-1-1': {'1:1': {top:617, left:160},
                '2:1': {top:542, left:0},
                '2:2': {top:542, left:106},
                '2:3': {top:542, left:212},
                '2:4': {top:542, left:320},
                '3:1': {top:442, left:0},
                '3:2': {top:452, left:86},
                '3:3': {top:452, left:232},
                '3:4': {top:442, left:320},
                '4:1': {top:417, left:160},
                '5:1': {top:347, left:160},
                },
      '4-4-2': {'1:1': {top:617, left:160},
                '2:1': {top:542, left:0},
                '2:2': {top:542, left:106},
                '2:3': {top:542, left:212},
                '2:4': {top:542, left:320},
                '3:1': {top:442, left:0},
                '3:2': {top:442, left:106},
                '3:3': {top:442, left:212},
                '3:4': {top:442, left:320},
                '4:1': {top:357, left:100},
                '4:2': {top:357, left:220},
                },
      '4-5-1': {'1:1': {top:617, left:160},
                '2:1': {top:542, left:0},
                '2:2': {top:542, left:106},
                '2:3': {top:542, left:212},
                '2:4': {top:542, left:320},
                '3:1': {top:447, left:0},
                '3:2': {top:457, left:80},
                '3:3': {top:467, left:160},
                '3:4': {top:457, left:240},
                '3:5': {top:447, left:320},
                '4:2': {top:357, left:160}
                },
      '5-3-2': {'1:1': {top:617, left:160},
                '2:1': {top:522, left:0},
                '2:2': {top:542, left:80},
                '2:3': {top:542, left:160},
                '2:4': {top:542, left:240},
                '2:5': {top:522, left:320},
                '3:1': {top:437, left:40},
                '3:2': {top:447, left:160},
                '3:3': {top:437, left:280},
                '4:1': {top:357, left:100},
                '4:2': {top:357, left:220}
                },
      '5-4-1': {'1:1': {top:617, left:160},
                '2:1': {top:522, left:0},
                '2:2': {top:542, left:80},
                '2:3': {top:542, left:160},
                '2:4': {top:542, left:240},
                '2:5': {top:522, left:320},
                '4:1': {top:427, left:0},
                '4:2': {top:427, left:96},
                '4:3': {top:427, left:220},
                '4:4': {top:427, left:320},
                '5:1': {top:347, left:160}
                },
    }

    # toppitchcoordpositionformationmatrix[:'3-4-3'][:'1:1'][:top]

    if side == "home"
      targetteamformation = @fixture.homeformation
      topcoord = homepitchcoordpositionformationmatrix[targetteamformation.to_sym][playergridposition.to_sym][:top]
      leftcoord = homepitchcoordpositionformationmatrix[targetteamformation.to_sym][playergridposition.to_sym][:left]
    elsif side == "away"
      targetteamformation = @fixture.awayformation
      topcoord = awaypitchcoordpositionformationmatrix[targetteamformation.to_sym][playergridposition.to_sym][:top]
      leftcoord = awaypitchcoordpositionformationmatrix[targetteamformation.to_sym][playergridposition.to_sym][:left]
    end

    return topcoord, leftcoord
  end

end


