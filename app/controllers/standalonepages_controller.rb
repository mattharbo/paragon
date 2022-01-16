class StandalonepagesController < ApplicationController
  def landing
  end

  def staging

    soccerapicall_getfixtureevents(718554) #nice vs. nantes 14 janvier
    # bdd id => 52

    @subs=0
    @goals=0

    @apiresponse_fixtureevents["response"].each do |event|

      if event["type"]=="subst"
        @subs+=1

        create_substitution(52,event["player"]["id"],event["assist"]["id"],event["time"]["elapsed"])

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

  def create_substitution(fixturebddid,playeroutid,playerinid,minute)

    # Recupération de la selection du player qui sort de jeu "player"
    target_selection_sub_out=Selection.where(fixture_id:fixturebddid).where(contract_id:Contract.where(player_id:Player.where(playerapiref:playeroutid).ids.last).last).last

    # Recupération du contract du player qui sort de jeu "player"
    target_contract_sub_out=Contract.where(player_id:Player.where(playerapiref:playeroutid).ids.last).last

    # Recupération de la selection du player qui entre en jeu "assist"
    target_selection_sub_in=Selection.where(fixture_id:fixturebddid).where(contract_id:Contract.where(player_id:Player.where(playerapiref:playerinid).ids.last).last).last

    # Recupération du contract du player qui entre en jeu "assist"
    target_contract_sub_in=Contract.where(player_id:Player.where(playerapiref:playerinid).ids.last).last

    # Mise à jour de la selection du player qui sort de jeu avec 
    # • la minute du changement
    # • le contract du joueur qui le remplace => le joueur entrant
    target_selection_sub_out.substitutiontime=minute
    target_selection_sub_out.substitute=target_contract_sub_in
    target_selection_sub_out.save

    # Mise à jour de la selection du player qui entre en jeu avec 
    # • la minute du changement
    # • le contract du joueur qui le remplace => le joueur entrant
    target_selection_sub_in.substitutiontime=minute
    target_selection_sub_in.substitute=target_contract_sub_out
    target_selection_sub_in.save
  end

  ####### FUNCTION ALREADY IN THE RAKE FILE #########


end