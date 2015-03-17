class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :user_votes
  has_many :items, through: :user_votes

  validates :first_name, presence: true 
  validates :last_name, presence: true 
  validates :password, length: { minimum: 8}
  validates :password, confirmation: true
  validates :password_confirmation, presence: true 
  validates :email, uniqueness: true 
end
