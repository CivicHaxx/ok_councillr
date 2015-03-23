require "councillors_wards"

puts "Destroying Councillors".red
Councillor.destroy_all
# puts "Destroying Committees".red
# Committee.destroy_all
puts "Destroying Users".red
User.destroy_all
#Agenda.destroy_all 
#Item.destroy_all
puts "Destroying Motions".red
Motion.destroy_all
puts "Destroying CouncillorVotes".red
CouncillorVote.destroy_all
puts "Destroying UserVotes".red
UserVote.destroy_all
puts "Destroying ItemTypes".red
#ItemType.destroy_all
puts "Destroying MotionTypes".red
MotionType.destroy_all
puts "Destroying Wards".red
Ward.destroy_all

prefix           = %w(EX CD GM PG)
user_votes       = %w(Yes No Skip)
councillor_votes = %w(Yes No Skip)
user_pc          = ["M1P 0B6", "M6H 2P2", "M5H 1K4", "M5H 2N2", "M2K 1E1", "M9V 1R8"]
users            = []
councillors      = []
wards            = []
people           = %w(👦 👧 👨 👩)

puts "Creating Motion Types".blue
motion_types = MotionType.create!([
	{ name: 'Adopted' }, 
	{ name: 'Received' },
	{ name: 'Amended' }
])

puts "Creating Users".blue
10.times do
	@user = User.create(
		email: Faker::Internet.safe_email,
		first_name: Faker::Name.first_name,
		last_name: Faker::Name.last_name,
		street_name: Faker::Address.street_address,
		street_num: Faker::Address.building_number,
		password: "password",
		password_confirmation: "password"
	)

	@user.save
	@user.activate!

	users << @user

	print " #{people.sample} "; print " "
end

puts "\nCreating Wards & Councillors".blue
WARD_INFO.each do |ward|
	wards << Ward.create!({ ward_number: ward[2], name: ward[3] })
	councillors << Councillor.create!({
			first_name: ward[1],
	    last_name: ward[0],
	    start_date_in_office: Faker::Date.backward(61),
	    website: Faker::Internet.url,
	    twitter_handle: Faker::Lorem.word,
	    facebook_handle: Faker::Lorem.word,
	    email: Faker::Internet.safe_email,
	    phone_number: Faker::PhoneNumber.phone_number,
	    address: Faker::Address.street_address,
	    image: Faker::Avatar.image,
	    ward: wards.last
	    })		
	print "👏"; print "  "
end

# This is now in the agenda_scraper this needs 
# shoulsd go into the counillers scrape when we are doing that scraper
# print "\nCreating City Council".blue
# council = Committee.create!({
#   name: "City Council",
# })

print "\nCreating City Council".blue

council = Committee.where("name = 'City Council'").first

councillors.each do |councillor|
	council.councillors << councillor
end
print " 👍"

puts "\nCreating Random Committees".yellow
rand(9).times do
	committee = Committee.create!(name: Faker::Company.name)

	5.times do
		committee.councillors << councillors.sample
	end
	print "❤️"; print " "
end

# puts "\nCreating Agendas and Items".blue
# Rake::Task['okc:agendas'].execute

# TODO: Create fake motions and on each item and fake user votes on each
#       motion. 
# NOTE: We are currently building the app so users can vote on items and not 
#       motions. Perhaps we should change this temporarily.

puts "Creating fake motions and votes".yellow
# Change this to the following when parsing ALL items
# Agenda.third.items.all.each do
Item.all.each do |item|
	rand(5).times do 
		motion_type    = motion_types.sample
		amendment_text = (motion_type.name == "Amended") ? Faker::Lorem.paragraph(4, true, 6) : ""
		
		motion = Motion.create!(
				amendment_text: amendment_text,
				councillor_id: councillors.sample.id,
				item_id: item.id,
				motion_type_id: motion_type.id
			)
		rand(10).times do
			CouncillorVote.create!(
				vote: councillor_votes.sample,
				councillor_id: councillors.sample.id,
				motion_id: motion.id
			)
		end

		rand(10).times do
			UserVote.create!(
				vote: user_votes.sample,
				user_id: users.sample.id,
				item_id: item.id
			)
		end
	end
	
	ward_number = item[:sections][:ward][0]

	unless ward_number == nil
	  item.wards << if(ward_number == "All") 
	  	Ward.all 
	  else
	  	Ward.find(ward_number.to_i)
	  end

	  item.save
	 end

	print "❤️"; print " "
end

print "\n💘 💘 💘\n";