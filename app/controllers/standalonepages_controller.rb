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

# ##################################################################################################
# ##################################################################################################
# ##################################################################################################

  private

end