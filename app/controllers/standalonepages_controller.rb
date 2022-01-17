class StandalonepagesController < ApplicationController
  def landing
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

  def soccerapicall_getfixtureevents(fixtureid)
    
    require 'uri'
    require 'net/http'
    require 'openssl'

    url = URI("https://api-football-v1.p.rapidapi.com/v3/fixtures/events?fixture=#{fixtureid}")

    apicredentials(url)

    return @apiresponse_fixtureevents=JSON.parse(@response.body)
  end

  def apicredentials(targeturl)

    http = Net::HTTP.new(targeturl.host, targeturl.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(targeturl)
    request["x-rapidapi-host"] = 'api-football-v1.p.rapidapi.com'
    request["x-rapidapi-key"] = 'QfDWrtMJ5wmsh1fjUZRYXaKkPpuvp1nv5hUjsnZgUbue0iFVJY'

    return @response = http.request(request)
  end

  ####### FUNCTION ALREADY IN THE RAKE FILE #########


end