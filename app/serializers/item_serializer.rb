class ItemSerializer < ActiveModel::Serializer
  attributes :id, :title, :number, :recommendations, :sections

  has_one :item_type
end
