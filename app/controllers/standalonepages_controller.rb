class StandalonepagesController < ApplicationController
  def landing
    @last_ligue1_games=Fixture.where('date >= ?', 5.day.ago)
  end

  def staging

    # St Etienne => 1063
    # Bordeaux => 78
    # Lorient => 97
    # troyes => 110
    # clermont => 99
    # metz => 112
    # Reims => 93
    # Brest => 106
    # Lyon => 80
    # Angers => 77
    # Lille => 79
    # Nantes => 83
    # Montpellier => 82
    # Strasbourg => 95
    # Lens => 116
    # Monaco => 91
    # Rennes => 94
    # Marseille => 81
    # Nice => 84
    # Paris => 85

  end

  def layout
  end

  def vip
  end

  def vipcompetitions
    @competitions=Competition.all
  end

  def vipseasons
    @seasons=Season.all
  end

  def vipcompetseasons
    @exercices=Competseason.all
  end

  def vipplayers
    @players=Player.all.order("id asc")
  end

  def vipteams
    @teams=Team.all.order("id ASC")
  end

  def vipcontracts
    @contracts=Contract.all
  end

  def vipfixtures
    @fixtures=Fixture.all.order("round DESC, date DESC")
  end

  def vipselections
    @selections=Selection.last(50).reverse
  end

  def vipevents
    @events=Event.all.order("id asc")
  end

  def vippositions
    @positions=Position.all.order("id asc")
  end

  def vipeventtypes
    @eventtypes=Eventtype.all.order("id asc")
  end

# ##################################################################################################
# ##################################################################################################
# ##################################################################################################

  private

end