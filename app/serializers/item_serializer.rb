class ItemSerializer < ActiveModel::Serializer
  attributes :id, :title, :number, :sections

  has_one :item_type
end
