class CouncillorVoteSerializer < ActiveModel::Serializer
  attributes :vote

  has_one :councillor
end
