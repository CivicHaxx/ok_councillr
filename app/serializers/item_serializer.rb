class ItemSerializer < ActiveModel::Serializer
  attributes :id, :title, :ward, :number

  has_one :item_type
end
