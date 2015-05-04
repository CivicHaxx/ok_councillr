require 'rails_helper'
require 'capybara/rspec'

RSpec.feature "Users", type: :feature do
	describe "#sign_up" do
		subject(:vist_sign_up) do
			visit(root_url)
	    click_link("Sign Up")
		end

		subject(:fill_in_require_fields) do
	  	user_new_password = "Pass3word:"

			fill_in "Email", with: Faker::Internet.free_email
			fill_in "First Name", with: Faker::Name.first_name
			fill_in "Last Name", with: Faker::Name.last_name
			fill_in "Password", with: user_new_password
	  	fill_in "Password Confirmation", with: user_new_password
		end

  	context "with all fields fill post" do
  		it "responds with 200" do
  			vist_sign_up

	  		within "#new_user" do					
					fill_in_require_fields
					fill_in "Street Name", with: "King Street W."
					fill_in "Street Number", with: 220
	  		end

	  		click_on "Sign Up"

	  		expect(page.status_code).to be(200)
  		end
  	end

  	context "with only require fields" do
  		it "responds with 200" do
  			vist_sign_up

	  		within "#new_user" do					
					fill_in_require_fields
	  		end

	  		click_on "Sign Up"

	  		expect(page.status_code).to be(200)
  		end
  	end
  end

  describe "#login" do
  	let(:user) { create(:user) }

		context "with email & password" do
  		it "responds with 200" do
	  		visit(root_url)
	      click_link "Login"

	  		within "form" do
	  			fill_in "Email", with: user.email
	  			fill_in "Password", with: "Pass3word:"
	  		end

	  		click_button "Login"
	  		expect(page.status_code).to be(200)
	  	end
	  end
  end
end
