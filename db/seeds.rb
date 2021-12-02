# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Competition.create(name:'Ligue 1 Uber Eat',country:'France')

Season.create(year:'2021-2022')

Competseason.create(competition:Competition.first,season:Season.first)

Team.create(name:'Angers SCO',shortname:'SCO')
Team.create(name:'AS Monaco',shortname:'ASM')
Team.create(name:'AS Saint-Étienne',shortname:'ASSE')
Team.create(name:'Clermont Foot 63',shortname:'CF63')
Team.create(name:'ES Troyes AC',shortname:'ESTAC')
Team.create(name:'FC Girondins de Bordeaux',shortname:'FCGB')
Team.create(name:'FC Lorient',shortname:'FCL')
Team.create(name:'FC Metz',shortname:'FCM')
Team.create(name:'FC Nantes',shortname:'FCN')
Team.create(name:'Lille OSC',shortname:'LOSC')
Team.create(name:'Montpellier Hérault SC',shortname:'MHSC')
Team.create(name:'OGC Nice',shortname:'OGCN')
Team.create(name:'Olympique de Marseille',shortname:'OM')
Team.create(name:'Olympique lyonnais',shortname:'OL')
Team.create(name:'Paris-SG',shortname:'PSG')
Team.create(name:'RC Lens',shortname:'RCL')
Team.create(name:'RC Strasbourg Alsace',shortname:'RCS')
Team.create(name:'Stade Brestois 29',shortname:'SB29')
Team.create(name:'Stade de Reims',shortname:'SdR')
Team.create(name:'Stade Rennais',shortname:'SR')