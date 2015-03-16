class MotionSerializer < ActiveModel::Serializer
  attributes :id, :amendment_text

	has_one :motion_type
end
