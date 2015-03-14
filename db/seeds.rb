# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ItemType.destroy_all 
User.destroy_all
Agenda.destroy_all 
Item.destroy_all
UserVote.destroy_all

item_types = ItemType.create([{ name: 'Action' }, { name: 'Information' }, { name: 'Presentation' }])

wards = %w(1 2 3 4 5 6 7 8 9 10 All)
prefix = %w(EX CD GM PG)
user_votes = %w(Yes No Skip)
user_pc = ["M1P 0B6", "M6H 2P2", "M5H 1K4", "M5H 2N2", "M2K 1E1", "M9V 1R8"]

users = []

10.times do
	users << User.create(
		email: Faker::Internet.safe_email,
		first_name: Faker::Name.first_name,
		last_name: Faker::Name.last_name,
		address: Faker::Address.street_address,
		postal_code: user_pc.sample,
		password: "password",
		password_confirmation: "password"
	)
end

2.times do 
	agenda = Agenda.create(
		date: Faker::Date.between(60.days.ago, Date.today)
	)

	100.times do
		item = Item.create(
			title: Faker::Hacker.say_something_smart, 
			ward: wards.sample,
			number: "#{prefix.sample}#{Faker::Number.number(1)}.#{Faker::Number.number(2)}",
			#sections: "#{Faker::Lorem.paragraphs(5)}",
      recommendations: "#{Faker::Company.bs} #{Faker::Company.catch_phrase}",
			item_type_id: item_types.sample.id, 
			agenda_id: agenda.id
		)

		rand(20).times do
			UserVote.create(
				vote: user_votes.sample,
				user_id: users.sample.id,
				item_id: item.id
			)
		end
	end
end