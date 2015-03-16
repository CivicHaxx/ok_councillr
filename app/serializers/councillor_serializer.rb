class CouncillorSerializer < ActiveModel::Serializer
	attributes :id, :first_name, :last_name, :start_date_in_office, :website, :twitter_handle, 
	:facebook_handle, :email, :phone_number, :address, :image
end
