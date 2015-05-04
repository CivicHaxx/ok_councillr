require 'active_record'
require 'active_support/all'
require 'awesome_print'
require 'colored'
require 'csv'
require 'http'
require 'nokogiri'
require 'open-uri'

require 'scraper'
require 'vote_scraper'
require 'agenda_scraper'
require 'parsed_item'
require 'minutes_scraper'
require "councillors_wards"


##################################################################
#                                                                #
# USERS                                                          #
#                                                                #
##################################################################

user_votes       = %w(Yes No Skip)
puts "Creating a fake user 🙋".yellow
@user = User.create!(
	email: Faker::Internet.safe_email,
	first_name: Faker::Name.first_name,
	last_name: Faker::Name.last_name,
	street_name: "King Street W.",
	street_num: 220,
	password: "password",
	password_confirmation: "password"
)

##################################################################
#                                                                #
# WARDS & COUNCILLORS                                            #
#                                                                #
##################################################################

puts "Destroying Councillors & Wards".red
Councillor.destroy_all
Ward.destroy_all
puts "Creating Wards & Councillors".blue
puts "NOTE: Councillors have fake contact info".yellow

# why do we need these in an arrays? do we use it later?
wards = []
councillors = []
WARD_INFO.each do |ward_info|
	wards << Ward.create!({ ward_number: ward_info[2], name: ward_info[3] })

	unless ward_info[1].empty?
		councillors << Councillor.create!({
				first_name: ward_info[1],
		    last_name: ward_info[0],
		    start_date_in_office: Faker::Date.backward(61),
		    website: Faker::Internet.domain_name,
		    twitter_handle: "@#{Faker::Internet.user_name}",
		    facebook_handle: Faker::Internet.user_name,
		    email: "councillor_#{ward_info[0].downcase}@toronto.ca",
		    phone_number: Faker::PhoneNumber.phone_number,
		    address: "100 Queen Street West, Toronto, ON",
		    image: Faker::Avatar.image, #"http://placehold.it/300/F2DFB7/00b783&text=Councillor+#{ward_info[0]}",
		    ward: wards.last
	   })
	end

	print "👏"; print "  "
end

##################################################################
#                                                                #
# CITY COUNCIL                                                   #
#                                                                #
##################################################################

puts "\nDestroying all committees".red
Committee.destroy_all

print "Creating City Council".blue
@council = Committee.create!({
  name: "City Council",
})

council = Committee.find_by_name("City Council")

councillors.each do |councillor|
	council.councillors << councillor
end
print " 👍\n"

##################################################################
#                                                                #
# OTHER COMMITTEES                                               #
#                                                                #
##################################################################

puts "Creating fake committees".yellow
rand(9).times do
	committee = Committee.create!(name: Faker::Company.name)

	5.times do
		committee.councillors << councillors.sample
	end
	print "❤️"; print " "
end

##################################################################
#                                                                #
# AGENDAS                                                        #
#                                                                #
##################################################################

puts "Destroying all agendas, items and itme types".red
Agenda.destroy_all 
Item.destroy_all
ItemType.destroy_all

puts "Creating item types".blue
item_types = ItemType.create!([
  { name: 'Action' }, 
  { name: 'Information' }, 
  { name: 'Presentation' }
])

# TO DO: Pass in a setup boolean. If true then scrape all the data. If false, 
#        check when it was run last and grab the new information.
puts "Parsing Agendas from this year".blue
AgendaScraper.new(DateTime.now).run


##################################################################
#                                                                #
# MOTIONS                                                        #
#                                                                #
##################################################################

puts "Destroying all motions and motion types".red
Motion.destroy_all
MotionType.destroy_all

puts "Creating motion types".blue
motion_types = MotionType.create!([
	{ name: 'Adopted' }, 
	{ name: 'Received' },
	{ name: 'Amended' }
])

##################################################################
#                                                                #
# VOTES RECORD                                                   #
#                                                                #
##################################################################

puts "Destroying the vote record".red
RawVoteRecord.destroy_all
today = Date.today.to_s
VoteScraper.new(6, "2014-12-01", today).run
# to change the date range and the term for the votes, you need
# to changne the above info and change the params for getting 
# the csvs. e.g., The decision body ID for 2014 is 961 but it is
# 261 for last term.

##################################################################
#                                                                #
# DONE! 			                                                   #
#                                                                #
##################################################################
puts ""
puts "############################".magenta_on_white
puts "                            ".magenta_on_white
puts "💖  You look great today!  💖 ".magenta_on_white
puts "                            ".magenta_on_white
puts "############################".magenta_on_white
puts ""
