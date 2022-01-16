desc "Insert latest ended Ligue 1 Game(s)"
task retrieve_latest_ligue_1_results: :environment do

	# soccerapicall_getfixtureslist(61,"#{Time.now.year}"+"-"+"#{sprintf('%02i', Time.now.month)}"+"-"+"#{sprintf('%02i', Time.now.day-1)}") 
	soccerapicall_getfixtureslist(61,"2021-10-22")

	if @apiresponse_fixturelist["results"]!=0

		@apiresponse_fixturelist["response"].each do |fixture|

			apifixtureid=fixture["fixture"]["id"]
			hometeam=checkteamname(fixture["teams"]["home"]["name"])
			awayteam=checkteamname(fixture["teams"]["away"]["name"])
			scorehome=fixture["goals"]["home"]
			scoreaway=fixture["goals"]["away"]
            fixtureround=fixture["league"]["round"].split.last
			Fixture.create(
				hometeam:hometeam,
				awayteam:awayteam,
				scorehome:scorehome,
				scoreaway:scoreaway,
				date:fixture["fixture"]["date"],
                competseason:Competseason.joins(:competition, :season).where("country like ?", "%France%").where("year like ?", "%2021-2022%").take,
                round:fixtureround
				)
			
			print "✅ for #{hometeam.name} vs. #{awayteam.name} \n"
			
			# RECUPERATION DE LA FORMATION DANS LE 2EME CALL API
			
			# RECUPERER LE FIXTURE API ID DE LA RENCONTRE 
			# ====> Il faudra prendre l'ID de la dernière fixture ajoutée en base
			fixturebddid=Fixture.last.id

			# FAIRE LE CALL API AFIN DE RECUPERER LES INFORMATIONS
			# soccerapicall_getfixturelineups(718512) # Lens vs. PSG
			soccerapicall_getfixturelineups(apifixtureid)

			i=0

			# POUR CHACUNE DES RESPONSES:
			@apiresponse_fixturelineups["response"].each do |team|

				# Récupération de l'instance bdd de l'équipe ciblée
				# Si 1 alors hometeam - Si 2 alors awayteam
				i+=1
		  
				# RECUPERER LA FORMATION dans response["formation"] 
				# & UPDATE LA FORMATION DANS LA TABLE FIXTURE (avec le FIXTURE ID de mon app)
				tt=defineteamandcreationformation(fixturebddid,i,team["formation"])
				
				# BOUCLER SUR TOUS LES JOEURS de ["startXI"]
				team["startXI"].each do |player|
			  
				  # SI LE JOUEUR EXISTE ALORS RECUPERER L'ID DE SON DERNIER CONTRACT
				  # SINON ALORS LE CREER, CREERE UN CONTRACT AVEC LA BONNE TEAM ET RECUPERER L'ID DU CONTRACT
				  #targetcontract:
				  tc=checkplayer(player["player"]["id"],player["player"]["name"],player["player"]["number"],tt)
				  
				  # CREER UNE SELECTION avec FIXTURE, CONTRACT et POSITION
				  createselection(tc,fixturebddid,player["player"]["pos"])
		  
				end
			end
		end
	end

	puts "⚽️ Ligue 1 game results checked on #{Time.now.year}-#{Time.now.month}-#{Time.now.day} @ #{Time.now.hour}:#{Time.now.min}"
end

########### Private functions ############


def apicredentials(targeturl)

    http = Net::HTTP.new(targeturl.host, targeturl.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(targeturl)
    request["x-rapidapi-host"] = 'api-football-v1.p.rapidapi.com'
    request["x-rapidapi-key"] = 'QfDWrtMJ5wmsh1fjUZRYXaKkPpuvp1nv5hUjsnZgUbue0iFVJY'

    return @response = http.request(request)
    
  end


def soccerapicall_getfixtureslist(league, date)

	# Ligue 1 ===> 61
	# Premiere league ===> 39
	# Date format ==> 2021-12-15
	
	require 'uri'
	require 'net/http'
	require 'openssl'

	url = URI("https://api-football-v1.p.rapidapi.com/v3/fixtures?league=#{league}&season=2021&date=#{date}")

	apicredentials(url)

	return @apiresponse_fixturelist=JSON.parse(@response.body)
end

def checkteamname(apiretrieveteamname)

	### ex: apiretrieveteamname = "Paris Saint Germain"

	check=Team.where("name like ?", "%#{apiretrieveteamname.split.last}%")

	if check.present?
		targetteam=check.take
	else
		Team.create(name:apiretrieveteamname)
		targetteam=Team.last
	end

	return targetteam
end

def soccerapicall_getfixturelineups(fixtureid)
    require 'uri'
    require 'net/http'
    require 'openssl'

    url = URI("https://api-football-v1.p.rapidapi.com/v3/fixtures/lineups?fixture=#{fixtureid}")

    apicredentials(url)
    
    return @apiresponse_fixturelineups=JSON.parse(@response.body)
end

def defineteamandcreationformation(fixtureid,teamindex,formation)
	targetfixture=Fixture.find(fixtureid)
	case teamindex
	when 1
		targetfixture.homeformation=formation
		targettedteam=targetfixture.hometeam
	when 2
		targetfixture.awayformation=formation
		targettedteam=targetfixture.awayteam
	end
	targetfixture.save
	return targettedteam
end

def checkplayer(apiretrievedplayerid,apiretrievedplayername,apiretrievedplayerjersey,bddteaminstance)

	check = Player.where("playerapiref like ?","%#{apiretrievedplayerid}%")

	if check.present?
		targetplayer=check.take
		# targetcontract=Contract.where(player:targetplayer)
		#Faut-il prendre le dernier contract connu? Contract.where(…).last
		targetcontract=Contract.where(player:targetplayer).last
	else
		#user & contract creation
		
		Player.create(
			name:apiretrievedplayername,
			playerapiref:apiretrievedplayerid
		)
		Contract.create(
			team:bddteaminstance,
			player:Player.last,
			jerseynumber:apiretrievedplayerjersey
		)
		targetcontract=Contract.last
	end
	return targetcontract
end

def createselection(coontract,fixture,position)
	Selection.create(
		contract:coontract,
		fixture:Fixture.find(fixture),
		starter:true
	)
end

############################################