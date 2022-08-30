desc "Retrieve Ligue 1 game with the API fixture ID"
task retrieve_L1_fixture_details_by_id: :environment do

	# ESTAC vs. SCO (28.08) => 871509
	# SdR vs. OL (28.08) => 871508
	# PSG vs. ASM (28.08) => 871505

	soccerapicall_getfixturedetails(871508)

	# Loop but should be an array of 1 (and only) 1 item

	@apiresponse_fixture_details["response"].each do |fixture|

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
                competseason:Competseason.joins(:competition, :season).where("country like ?", "%France%").where("year like ?", "%2022-2023%").take,
                round:fixtureround
				)
			
			# RECUPERER LE FIXTURE ID DE LA RENCONTRE (dernière fixture ajoutée en base)
			fixturebddid=Fixture.last.id

			# CALL API AFIN DE RECUPERER LES LINEUPS
			soccerapicall_getfixturelineups(apifixtureid)

			i=0

			@apiresponse_fixturelineups["response"].each do |team|

				# Si 1 alors hometeam - Si 2 alors awayteam
				i+=1
		  
				# RECUPERER LA FORMATION dans response["formation"] 
				# & UPDATE LA FORMATION DANS LA TABLE FIXTURE (avec le FIXTURE ID de mon app)
				target_team_id=defineteamandcreationformation(fixturebddid,i,team["formation"])
				
				# BOUCLER SUR TOUS LES JOEURS de ["startXI"]
				team["startXI"].each do |player|
			  
				  # SI LE JOUEUR EXISTE ALORS RECUPERER L'ID DE SON DERNIER CONTRACT
				  # SINON ALORS LE CREER, CREER UN CONTRACT AVEC LA BONNE TEAM ET RECUPERER L'ID DU CONTRACT
				  target_contract=checkplayer(player["player"]["id"],player["player"]["name"],player["player"]["number"],target_team_id)
				  
				  # CREER UNE SELECTION avec FIXTURE, CONTRACT et POSITION
				  createselection(target_contract,fixturebddid,player["player"]["pos"],true,player["player"]["grid"])
				end

				#Boucler sur tous les joueurs sur le banc ["substitutes"]
				team["substitutes"].each do |benchplayer|
			  
				  # SI LE JOUEUR EXISTE ALORS RECUPERER L'ID DE SON DERNIER CONTRACT
				  # SINON ALORS LE CREER, CREERE UN CONTRACT AVEC LA BONNE TEAM ET RECUPERER L'ID DU CONTRACT
				  target_contract=checkplayer(benchplayer["player"]["id"],benchplayer["player"]["name"],benchplayer["player"]["number"],target_team_id)
				  
				  # CREER UNE SELECTION avec FIXTURE, CONTRACT et POSITION
				  createselection(target_contract,fixturebddid,benchplayer["player"]["pos"],false,benchplayer["player"]["grid"])
				end
			end

			# CALL API AFIN DE METTRE A JOUR TOUS LES CHANGEMENTS (& LES BUTS)
			soccerapicall_getfixtureevents(apifixtureid)

			@apiresponse_fixtureevents["response"].each do |event|

		      if event["type"]=="subst"
		        create_substitution(fixturebddid,event["player"]["id"],event["assist"]["id"],event["time"]["elapsed"])

		      elsif event["type"]=="Goal"

		      	case event["detail"]
		      	when "Normal Goal"
		      		create_event(fixturebddid,event["player"]["id"],Eventtype.where("description like ?", "%Goal%").take,event["time"]["elapsed"])
		      	when "Own Goal"
		      		create_event(fixturebddid,event["player"]["id"],Eventtype.where("description like ?", "%Auto%").take,event["time"]["elapsed"])
		      	when "Penalty"
		      		create_event(fixturebddid,event["player"]["id"],Eventtype.where("description like ?", "%Penalty%").take,event["time"]["elapsed"])
		      	end

		      end
		    end

			# CALL API AFIN DE RECUPERER LES NOTES DE CHACUN DES JOEURS
			soccerapicall_getfixtureplayersstats(apifixtureid)

			@apiresponse_fixtureplayersstats["response"].each do |team|

		      team["players"].each do |player|

		        target_selection_for_rating=Selection.where(fixture_id:fixturebddid).where(contract_id:Contract.where(player_id:Player.where(playerapiref:player["player"]["id"]).ids.last).last).last

		        print "#️⃣ #{player["statistics"][0]["games"]["rating"]}"
		        print "\n"

		        target_selection_for_rating.note=player["statistics"][0]["games"]["rating"].to_f
		        target_selection_for_rating.save

		      end
		    end

	
	print "Ligue 1 fixture details retrieved ✅ for #{hometeam.name} vs. #{awayteam.name} \n"
	end

	puts "on #{Time.now.year}-#{Time.now.month}-#{Time.now.day} @ #{Time.now.hour}:#{Time.now.min}"

end

desc "Insert latest ended Ligue 1 Game(s)"
task retrieve_latest_ligue_1_results: :environment do

	soccerapicall_getfixtureslist(61,"#{Time.now.year}"+"-"+"#{sprintf('%02i', Time.now.month)}"+"-"+"#{sprintf('%02i', Time.now.day-1)}") 
	# soccerapicall_getfixtureslist(61,"2022-08-21")

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
                competseason:Competseason.joins(:competition, :season).where("country like ?", "%France%").where("year like ?", "%2022-2023%").take,
                round:fixtureround
				)
			
			print "✅ for #{hometeam.name} vs. #{awayteam.name} \n"
			
			# RECUPERER LE FIXTURE ID DE LA RENCONTRE (dernière fixture ajoutée en base)
			fixturebddid=Fixture.last.id

			# CALL API AFIN DE RECUPERER LES LINEUPS
			soccerapicall_getfixturelineups(apifixtureid)

			i=0

			@apiresponse_fixturelineups["response"].each do |team|

				# Si 1 alors hometeam - Si 2 alors awayteam
				i+=1
		  
				# RECUPERER LA FORMATION dans response["formation"] 
				# & UPDATE LA FORMATION DANS LA TABLE FIXTURE (avec le FIXTURE ID de mon app)
				target_team_id=defineteamandcreationformation(fixturebddid,i,team["formation"])
				
				# BOUCLER SUR TOUS LES JOEURS de ["startXI"]
				team["startXI"].each do |player|
			  
				  # SI LE JOUEUR EXISTE ALORS RECUPERER L'ID DE SON DERNIER CONTRACT
				  # SINON ALORS LE CREER, CREER UN CONTRACT AVEC LA BONNE TEAM ET RECUPERER L'ID DU CONTRACT
				  target_contract=checkplayer(player["player"]["id"],player["player"]["name"],player["player"]["number"],target_team_id)
				  
				  # CREER UNE SELECTION avec FIXTURE, CONTRACT et POSITION
				  createselection(target_contract,fixturebddid,player["player"]["pos"],true,player["player"]["grid"])
				end

				#Boucler sur tous les joueurs sur le banc ["substitutes"]
				team["substitutes"].each do |benchplayer|
			  
				  # SI LE JOUEUR EXISTE ALORS RECUPERER L'ID DE SON DERNIER CONTRACT
				  # SINON ALORS LE CREER, CREERE UN CONTRACT AVEC LA BONNE TEAM ET RECUPERER L'ID DU CONTRACT
				  target_contract=checkplayer(benchplayer["player"]["id"],benchplayer["player"]["name"],benchplayer["player"]["number"],target_team_id)
				  
				  # CREER UNE SELECTION avec FIXTURE, CONTRACT et POSITION
				  createselection(target_contract,fixturebddid,benchplayer["player"]["pos"],false,benchplayer["player"]["grid"])
				end
			end

			# CALL API AFIN DE METTRE A JOUR TOUS LES CHANGEMENTS (& LES BUTS)
			soccerapicall_getfixtureevents(apifixtureid)

			@apiresponse_fixtureevents["response"].each do |event|

		      if event["type"]=="subst"
		        create_substitution(fixturebddid,event["player"]["id"],event["assist"]["id"],event["time"]["elapsed"])

		      elsif event["type"]=="Goal"

		      	case event["detail"]
		      	when "Normal Goal"
		      		create_event(fixturebddid,event["player"]["id"],Eventtype.where("description like ?", "%Goal%").take,event["time"]["elapsed"])
		      	when "Own Goal"
		      		create_event(fixturebddid,event["player"]["id"],Eventtype.where("description like ?", "%Auto%").take,event["time"]["elapsed"])
		      	when "Penalty"
		      		create_event(fixturebddid,event["player"]["id"],Eventtype.where("description like ?", "%Penalty%").take,event["time"]["elapsed"])
		      	end

		      end
		    end

			# CALL API AFIN DE RECUPERER LES NOTES DE CHACUN DES JOEURS
			soccerapicall_getfixtureplayersstats(apifixtureid)

			@apiresponse_fixtureplayersstats["response"].each do |team|

		      team["players"].each do |player|

		        target_selection_for_rating=Selection.where(fixture_id:fixturebddid).where(contract_id:Contract.where(player_id:Player.where(playerapiref:player["player"]["id"]).ids.last).last).last

		        print "#️⃣ #{player["statistics"][0]["games"]["rating"]}"
		        print "\n"

		        target_selection_for_rating.note=player["statistics"][0]["games"]["rating"].to_f
		        target_selection_for_rating.save

		      end
		    end

		end
	end

	puts "🗓 Ligue 1 game results checked on #{Time.now.year}-#{Time.now.month}-#{Time.now.day} @ #{Time.now.hour}:#{Time.now.min}"
end

desc "Insert latest ended Champions league Game(s)"
task retrieve_latest_CL_results: :environment do

	soccerapicall_getfixtureslist(2,"#{Time.now.year}"+"-"+"#{sprintf('%02i', Time.now.month)}"+"-"+"#{sprintf('%02i', Time.now.day-1)}") 
	# soccerapicall_getfixtureslist(2,"2022-05-04")

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
                competseason:Competseason.joins(:competition, :season).where("country like ?", "%Europe%").where("year like ?", "%2022-2023%").take,
                round:fixtureround
				)
			
			print "✅ for #{hometeam.name} vs. #{awayteam.name} \n"
			
			# RECUPERER LE FIXTURE ID DE LA RENCONTRE (dernière fixture ajoutée en base)
			fixturebddid=Fixture.last.id

			# CALL API AFIN DE RECUPERER LES LINEUPS
			soccerapicall_getfixturelineups(apifixtureid)

			i=0

			@apiresponse_fixturelineups["response"].each do |team|

				# Si 1 alors hometeam - Si 2 alors awayteam
				i+=1
		  
				# RECUPERER LA FORMATION dans response["formation"] 
				# & UPDATE LA FORMATION DANS LA TABLE FIXTURE (avec le FIXTURE ID de mon app)
				target_team_id=defineteamandcreationformation(fixturebddid,i,team["formation"])
				
				# BOUCLER SUR TOUS LES JOEURS de ["startXI"]
				team["startXI"].each do |player|
			  
				  # SI LE JOUEUR EXISTE ALORS RECUPERER L'ID DE SON DERNIER CONTRACT
				  # SINON ALORS LE CREER, CREERE UN CONTRACT AVEC LA BONNE TEAM ET RECUPERER L'ID DU CONTRACT
				  target_contract=checkplayer(player["player"]["id"],player["player"]["name"],player["player"]["number"],target_team_id)
				  
				  # CREER UNE SELECTION avec FIXTURE, CONTRACT et POSITION
				  createselection(target_contract,fixturebddid,player["player"]["pos"],true,player["player"]["grid"])
				end

				#Boucler sur tous les joueurs sur le banc ["substitutes"]
				team["substitutes"].each do |benchplayer|
			  
				  # SI LE JOUEUR EXISTE ALORS RECUPERER L'ID DE SON DERNIER CONTRACT
				  # SINON ALORS LE CREER, CREERE UN CONTRACT AVEC LA BONNE TEAM ET RECUPERER L'ID DU CONTRACT
				  target_contract=checkplayer(benchplayer["player"]["id"],benchplayer["player"]["name"],benchplayer["player"]["number"],target_team_id)
				  
				  # CREER UNE SELECTION avec FIXTURE, CONTRACT et POSITION
				  createselection(target_contract,fixturebddid,benchplayer["player"]["pos"],false,player["player"]["grid"])
				end
			end

			# CALL API AFIN DE METTRE A JOUR TOUS LES CHANGEMENTS (& LES BUTS)
			soccerapicall_getfixtureevents(apifixtureid)

			@apiresponse_fixtureevents["response"].each do |event|

		      if event["type"]=="subst"
		        create_substitution(fixturebddid,event["player"]["id"],event["assist"]["id"],event["time"]["elapsed"])

		      elsif event["type"]=="Goal"
		        
		      	case event["detail"]
		      	when "Normal Goal"
		      		create_event(fixturebddid,event["player"]["id"],Eventtype.where("description like ?", "%Goal%").take,event["time"]["elapsed"])
		      	when "Own Goal"
		      		create_event(fixturebddid,event["player"]["id"],Eventtype.where("description like ?", "%Auto%").take,event["time"]["elapsed"])
		      	when "Penalty"
		      		create_event(fixturebddid,event["player"]["id"],Eventtype.where("description like ?", "%Penalty%").take,event["time"]["elapsed"])
		      	end
		        
		      end
		    end

			# CALL API AFIN DE RECUPERER LES NOTES DE CHACUN DES JOEURS
			soccerapicall_getfixtureplayersstats(apifixtureid)

			@apiresponse_fixtureplayersstats["response"].each do |team|

		      team["players"].each do |player|

		        target_selection_for_rating=Selection.where(fixture_id:fixturebddid).where(contract_id:Contract.where(player_id:Player.where(playerapiref:player["player"]["id"]).ids.last).last).last

		        print "#️⃣ #{player["statistics"][0]["games"]["rating"]}"
		        print "\n"

		        target_selection_for_rating.note=player["statistics"][0]["games"]["rating"].to_f
		        target_selection_for_rating.save

		      end
		    end

		end
	end

	puts "🎉 Champions League game results checked on #{Time.now.year}-#{Time.now.month}-#{Time.now.day} @ #{Time.now.hour}:#{Time.now.min}"
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

def soccerapicall_getfixturedetails(fixtureapiid)

	require 'uri'
	require 'net/http'
	require 'openssl'

	url = URI("https://api-football-v1.p.rapidapi.com/v3/fixtures?id=#{fixtureapiid}")

	apicredentials(url)

	return @apiresponse_fixture_details=JSON.parse(@response.body)
	
end

def soccerapicall_getfixtureslist(league, date)

	# Ligue 1 ===> 61
	# Premiere league ===> 39
	# World cup ===> 1
	# Champions league ===> 2
	# Coupe de France ===> 66
	# Trophée des Champions France ===> inexistant
	# Date format ==> 2021-12-15
	
	require 'uri'
	require 'net/http'
	require 'openssl'

	url = URI("https://api-football-v1.p.rapidapi.com/v3/fixtures?league=#{league}&season=2022&date=#{date}")

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

def soccerapicall_getfixtureplayersstats(fixtureid)
    
    require 'uri'
    require 'net/http'
    require 'openssl'

    url = URI("https://api-football-v1.p.rapidapi.com/v3/fixtures/players?fixture=#{fixtureid}")

    apicredentials(url)

    return @apiresponse_fixtureplayersstats=JSON.parse(@response.body)
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

	check = Player.where(playerapiref:apiretrievedplayerid)

	# Si présent en base [⚠️⚠️ À FAIRE !!!!!⚠️⚠️] ET si le dernier contrat correspond bien à l'équipe de la fixture alors récupérer le contrat
	if check.present?
		targetplayer=check.take
		#Faut-il prendre le dernier contract connu? Contract.where(…).last
		targetcontract=Contract.where(player:targetplayer).last
		print "Contract retrieved from DB (with #{apiretrievedplayerid} player API id)"
		print "\n"
	else
		#user & contract creation	
		Player.create(
			name:apiretrievedplayername,
			playerapiref:apiretrievedplayerid
		)
		print "#{apiretrievedplayername} player created in DB with the player API id => #{apiretrievedplayerid}"
		print "\n"
		Contract.create(
			team:bddteaminstance,
			player:Player.last,
			jerseynumber:apiretrievedplayerjersey
		)
		targetcontract=Contract.last
	end
	return targetcontract
end

def createselection(coontract,fixture,position,status,grid)
	Selection.create(
		contract:coontract,
		fixture:Fixture.find(fixture),
		starter:status,
		grid_pos:grid
	)
end

def soccerapicall_getfixtureevents(fixtureid)
    
    require 'uri'
    require 'net/http'
    require 'openssl'

    url = URI("https://api-football-v1.p.rapidapi.com/v3/fixtures/events?fixture=#{fixtureid}")

    apicredentials(url)

    return @apiresponse_fixtureevents=JSON.parse(@response.body)
end

def create_substitution(fixturebddid,playeroutid,playerinid,minute)

	print "------------------"
	print "Fixture bdd ==> #{fixturebddid}"
	print "\n"
	print "Ref player out ==> #{playeroutid}"
	print "\n"
	print "Ref player in ==> #{playerinid}"
	print "\n"

	# check_out = Player.where("playerapiref like ?","%#{playeroutid}%")
	# check_in = Player.where("playerapiref like ?","%#{playerinid}%")
	check_out = Player.where(playerapiref:playeroutid)
	check_in = Player.where(playerapiref:playerinid)

	if check_out.present? and check_in.present?
		# Recupération de la selection du player qui sort de jeu player
	    target_selection_sub_out=Selection.where(fixture_id:fixturebddid).where(contract_id:Contract.where(player_id:Player.where(playerapiref:playeroutid).ids.last).last).last
	    print "🔴▶️ Sub out: #{target_selection_sub_out}"
	    print "\n"

	    # Recupération du contract du player qui sort de jeu "player"
	    target_contract_sub_out=Contract.where(player_id:Player.where(playerapiref:"#{playeroutid}").ids.last).last
	    print "🔴📑 Contract out: #{target_contract_sub_out}"
	    print "\n"

	    # Recupération de la selection du player qui entre en jeu "assist"
	    target_selection_sub_in=Selection.where(fixture_id:"#{fixturebddid}").where(contract_id:Contract.where(player_id:Player.where(playerapiref:"#{playerinid}").ids.last).last).last
	    print "🟢◀️ Sub in: #{target_selection_sub_in}"
	    print "\n"

	    # Recupération du contract du player qui entre en jeu "assist"
	    target_contract_sub_in=Contract.where(player_id:Player.where(playerapiref:"#{playerinid}").ids.last).last
	    print "🟢📑 Contract in: #{target_contract_sub_in}"
	    print "\n"

	    # Mise à jour de la selection du player qui sort de jeu avec 
	    # • la minute du changement
	    # • le contract du joueur qui le remplace => le joueur entrant
	    target_selection_sub_out.substitutiontime=minute.to_i
	    target_selection_sub_out.substitute=target_contract_sub_in
	    print "➡️ Set sub out replacement"
	    print "\n"
	    target_selection_sub_out.save
	    print "💾 Save sub out replacement"
	    print "\n"

	    # Mise à jour de la selection du player qui entre en jeu avec 
	    # • la minute du changement
	    # • le contract du joueur qui le remplace => le joueur entrant
	    target_selection_sub_in.substitutiontime=minute.to_i
	    target_selection_sub_in.substitute=target_contract_sub_out
	    print "⬅️ Set sub in replacement"
	    print "\n"
	    target_selection_sub_in.save
	    print "💾 Save sub in replacement"
	    print "\n"
	end
end

def create_event(fixturebddid,player,eventtype,minute)

	main_actor = Player.where(playerapiref:player)

	if main_actor.present?

		# Recupération de la selection du player
	    target_selection=Selection.where(fixture_id:fixturebddid).where(contract_id:Contract.where(player_id:Player.where(playerapiref:player).ids.last).last).last
	    print "⚽️ Selection of the scorer: #{target_selection} "

	    Event.create(selection:target_selection,eventtype:eventtype,time:minute.to_i,registration:false)

	    print " and creation of the goal event for the selection"
	    print "\n"

	end
end

############################################