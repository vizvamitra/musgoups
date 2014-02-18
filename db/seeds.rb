# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Group.delete_all
Group.create!(title: 'Deep Purple', formation_year:1968, country:'Great Britain', top_position:1)
Group.create!(title: 'Metallica', formation_year:1981, country:'USA', top_position:2)
Group.create!(title: 'Megadeth', formation_year:1983, country:'USA', top_position:3)
Group.create!(title: 'Scorpions', formation_year:1965, country:'Germany', top_position:4)
Group.create!(title: 'Nightwish', formation_year:1996, country:'Finland', top_position:5)
Group.create!(title: 'Blackmore’s Night', formation_year:1997, country:'USA', top_position:6)

Member.delete_all
Member.create!(name: 'Ian Gillan', role:'Вокал', birth_date:'1945-08-19 00:00:00', group_id:1)
Member.create!(name: 'Steven J. Morse', role:'Гитара', birth_date:'1954-07-24 00:00:00', group_id:1)
Member.create!(name: 'Roger David Glover', role:'Бас-гитара', birth_date:'1945-11-30 00:00:00', group_id:1)
Member.create!(name: 'Don Airey', role:'Клавиши', birth_date:'1948-06-21 00:00:00', group_id:1)
Member.create!(name: 'Ian Anderson Paice', role:'Ударные', birth_date:'1948-06-29 00:00:00', group_id:1)