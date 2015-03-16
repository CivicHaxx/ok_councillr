class MotionDetailSerializer < ActiveModel::Serializer
	attributes :id, :amendment_text

	has_one :councillor
  has_one :item
  has_one :motion_type
  has_many :councillor_votes
end
