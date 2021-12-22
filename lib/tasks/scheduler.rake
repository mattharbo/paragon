desc "Insert Ligue 1 Game(s) of the day"
task retrieve_ligue_1_gotd: :environment do

	soccerapicall(61,"#{Time.now.year}"+"-"+"#{Time.now.month}"+"-"+"#{Time.now.day-1}") 
	# soccerapicall(61,"2021-12-04")

	if @apiresponse["results"]!=0

			@apiresponse["response"].each do |fixture|

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
		end
	end

	puts "⚽️ Ligue 1 game results checked on #{Time.now.year}-#{Time.now.month}-#{Time.now.day} @ #{Time.now.hour}:#{Time.now.min}"
end

def soccerapicall(league, date)

	# Ligue 1 ===> 61
	# Premiere league ===> 39
	# Date format ==> 2021-12-15
	
	require 'uri'
	require 'net/http'
	require 'openssl'

	url = URI("https://api-football-v1.p.rapidapi.com/v3/fixtures?league=#{league}&season=2021&date=#{date}")

	http = Net::HTTP.new(url.host, url.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Get.new(url)
	request["x-rapidapi-host"] = 'api-football-v1.p.rapidapi.com'
	request["x-rapidapi-key"] = 'QfDWrtMJ5wmsh1fjUZRYXaKkPpuvp1nv5hUjsnZgUbue0iFVJY'

	response = http.request(request)

	return @apiresponse=JSON.parse(response.body)
end

def checkteamname(apiretrieveteamname)

	### ex: apiretrieveteamname = "Paris Saint Germain"

	check=Team.where("name like ?", "%#{apiretrieveteamname.split.last}%")

	if check.present?
		targetteam=Team.where("name like ?", "%#{apiretrieveteamname.split.first}%").take
	else
		Team.create(name:apiretrieveteamname)
		targetteam=Team.last
	end

	return targetteam
end