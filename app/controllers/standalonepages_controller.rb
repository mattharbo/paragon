class StandalonepagesController < ApplicationController
  
  # To by-pass Devise authentication on some specific actions
    skip_before_action :authenticate_user!, only: [:landing]

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
    @fixturescount=Fixture.count
    @playerscount=Player.count
    @contractscount=Contract.count
    @selectionscount=Selection.count
    @eventscount=Event.count
    @newfixturescount=Fixture.where('created_at >= ?', 5.day.ago).count
    @newteamscount=Team.where('created_at >= ?', 5.day.ago).count
    @newplayerscount=Player.where('created_at >= ?', 5.day.ago).count
    @uneditedplayerscount=Player.where('updated_at = created_at').where('firstname': nil).count
    @unsubmittedfixtures=Fixture.where(submitted:[false,nil]).count
    @enregisteredevents=Event.where(registration:[false,nil]).count
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
    @players=Player.all.order("id desc")
  end

  def vipteams
    @teams=Team.all.order("id ASC")
  end

  def vipcontracts
    @contracts=Contract.all
  end

  def vipfixtures
    @fixtures=Fixture.all.order("date desc")
  end

  def vipselections
    @selections=Selection.last(150).reverse
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

  def vipkits
    @kits=Kit.all.order("id asc")
  end

# ##################################################################################################
# ##################################################################################################
# ##################################################################################################

  private

end