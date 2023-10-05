class User < ApplicationRecord
  has_secure_password
  has_many :locations, dependent: :destroy

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  attribute :username
  attribute :pending_request_ids, :json, default: []
  validates :username, presence: true, uniqueness: true, length: { minimum: 3 }, format: { with: /\A\w+\z/, message: "can only contain letters, numbers, and underscores" }, allow_blank: true
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true

  before_validation :check_username_presence

  private

  def check_username_presence
    self.username = nil if username.blank?
  end

end
