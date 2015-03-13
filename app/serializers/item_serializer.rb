class ItemSerializer < ActiveModel::Serializer
  attributes :id, :title, :ward, :number

  has_many :user_votes
end
