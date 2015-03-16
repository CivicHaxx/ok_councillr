# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Councillor.destroy_all
Committee.destroy_all
User.destroy_all
Agenda.destroy_all 
Item.destroy_all
Motion.destroy_all
CouncillorVote.destroy_all
UserVote.destroy_all
ItemType.destroy_all
MotionType.destroy_all
Ward.destroy_all

prefix = %w(EX CD GM PG)
user_votes = %w(Yes No Skip)
councillor_votes = %w(Yes No Absent)
user_pc = ["M1P 0B6", "M6H 2P2", "M5H 1K4", "M5H 2N2", "M2K 1E1", "M9V 1R8"]
users = []
councillors = []
wards = []

item_types = ItemType.create([{ name: 'Action' }, { name: 'Information' }, { name: 'Presentation' }])
motion_types = MotionType.create([{ name: 'Adopted' }, { name: 'Received' }, { name: 'Amended' }])
44.times { |ward_number| wards << Ward.create(ward_number: ward_number,	name: Faker::Company.name) }

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
	print "❤️"; print " "
end

wards.each do |ward|
	councillors << Councillor.create(
			first_name: Faker::Name.first_name,
	    last_name: Faker::Name.last_name,
	    start_date_in_office: Faker::Date.backward(61),
	    website: Faker::Internet.url,
	    twitter_handle: Faker::Lorem.word,
	    facebook_handle: Faker::Lorem.word,
	    email: Faker::Internet.safe_email,
	    phone_number: Faker::PhoneNumber.phone_number,
	    address: Faker::Address.street_address,
	    image: Faker::Avatar.image,
	    ward: ward
		)
	print "❤️"; print " "
end

rand(10).times do
	committee = Committee.create(name: Faker::Company.name)

	5.times do
		committee.councillors << councillors.sample
	end
	print "❤️"; print " "
end

2.times do 
	agenda = Agenda.create(
		date: Faker::Date.between(60.days.ago, Date.today)
	)

	100.times do |index|
		current_origin_from = ((index % 2) == 0) ? agenda : councillors.sample

item = Item.create(
			title: Faker::Hacker.say_something_smart, 
			wards: wards[1...rand(wards.count)],
			number: "#{prefix.sample}#{Faker::Number.number(1)}.#{Faker::Number.number(2)}",
			sections: {	"Recommendations" => "#{Faker::Lorem.paragraphs(5)}",
									"Origin" => "#{Faker::Lorem.paragraphs(5)}",
									"Summary" => "#{Faker::Lorem.paragraphs(5)}",
									"Background Information" => "#{Faker::Lorem.paragraphs(5)}"},
      recommendations: "#{Faker::Company.bs} #{Faker::Company.catch_phrase}",
			item_type_id: item_types.sample.id,
			origin: current_origin_from
		)

		rand(20).times do
			motion_type = motion_types.sample
			amendment_text = (motion_type.name == "Amended") ? Faker::Lorem.paragraph(4, true, 6) : ""

			motion = Motion.create(
				amendment_text: amendment_text,
				councillor_id: councillors.sample.id,
				item_id: item.id,
				motion_type_id: motion_type.id
			)

			rand(20).times do
				CouncillorVote.create(
					vote: councillor_votes.sample,
					councillor_id: councillors.sample.id,
					motion_id: motion.id
				)
			end
		end

		rand(20).times do
			UserVote.create(
				vote: user_votes.sample,
				user_id: users.sample.id,
				item_id: item.id
			)
		end
		print "❤️"; print " "
	end
print "💘💘💘"; print " "
end