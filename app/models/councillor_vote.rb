class CouncillorVote < ActiveRecord::Base
  belongs_to :motion
  belongs_to :councillor
end
