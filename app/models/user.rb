class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :user_votes
  has_many :items, through: :user_votes
  belongs_to :ward

  validates :email, presence: true 
  validates :first_name, presence: true
  validates :last_name, presence: true 
  validates :password, length: { minimum: 8 }, unless: :allow_to_validate
  validates :password, confirmation: true
  validates :password_confirmation, presence: true, on: :create, unless: :allow_to_validate
  validates :email, uniqueness: true

  def display_full_name
    "#{first_name} #{last_name}"
  end

  def allow_to_validate
    password.blank?
  end

  def has_no_votes?
  	user_votes.count == 0
  end
end
