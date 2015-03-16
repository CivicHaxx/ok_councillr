class CommitteeSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :agendas
end
