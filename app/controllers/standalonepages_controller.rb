class StandalonepagesController < ApplicationController
  def landing
    @all_event = Event.where(eventtype_id:Eventtype.where("description like ?", "%Goal%")).or(Event.where(eventtype_id:Eventtype.where("description like ?", "%Auto%"))).or(Event.where(eventtype_id:Eventtype.where("description like ?", "%Penalty%")))
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

# ##################################################################################################
# ##################################################################################################
# ##################################################################################################

  private

end