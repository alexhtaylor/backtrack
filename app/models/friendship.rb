class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :user_id, presence: true
  validates :friend_id, presence: true
  validate :not_self

  private

  def not_self
    errors.add(:friend, "can't be equal to user") if user == friend
  end
end
