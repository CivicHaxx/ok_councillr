class AgendaSerializer < ActiveModel::Serializer
  attributes :id, :date

  has_many :items
end
