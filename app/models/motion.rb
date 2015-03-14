class Motion < ActiveRecord::Base
  belongs_to :councillor
  belongs_to :item
  belongs_to :motion_type

  has_many :councillor_votes
end
