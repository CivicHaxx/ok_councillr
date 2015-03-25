class CouncillorDetailSerializer < ActiveModel::Serializer
	attributes :id, :first_name, :last_name, :start_date_in_office, :website, :twitter_handle, 
	:facebook_handle, :email, :phone_number, :address, :image

	has_one :ward
	has_many :motions
	has_many :councillor_votes
	has_many :items, as: :origin
end
