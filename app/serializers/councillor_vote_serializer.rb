class CouncillorVoteSerializer < ActiveModel::Serializer
  attributes :vote

  has_one :councillor
  has_one :motion
end
