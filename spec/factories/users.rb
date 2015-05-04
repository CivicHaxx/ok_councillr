FactoryGirl.define do
  factory :user do
	  user_new_password = "Pass3word:"

    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
		street_name{ "King Street W." }
		street_num { 220 }
    email      { Faker::Internet.free_email }
    password   { user_new_password }
    password_confirmation { user_new_password }
  end
end
