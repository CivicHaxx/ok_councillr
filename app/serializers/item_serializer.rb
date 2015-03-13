class ItemSerializer < ActiveModel::Serializer
  attributes :id, :title, :ward, :number, :recommendations, :sections

  has_one :item_type
end
