class StandalonepagesController < ApplicationController
  def landing
  end

  def staging

    soccerapicall_getfixtureevents(718512)

    @subs=0
    @goals=0

    @apiresponse_fixtureevents["response"].each do |event|

      if event["type"]=="subst"
        @subs+=1

       # is the entry player exist?

      elsif event["type"]=="Goal"
        @goals+=1
      end

    end

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