class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :user_votes
  has_many :items, through: :user_votes

  validates :first_name, presence: true 
  validates :last_name, presence: true 
  validates :password, length: { minimum: 8}, unless: Proc.new { |a| a.password.blank? }
  validates :password, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :email, uniqueness: true

  def has_no_votes?
  	user_votes.count == 0
  end
end
