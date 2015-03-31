class ItemSerializer < ActiveModel::Serializer
  attributes :id, :title, :number, :synopsis, :sections

  has_one :item_type
end
