class Location < ApplicationRecord
  belongs_to :user

  validates :datetime, presence: true
  validates :latitude, presence: true, numericality: true
  validates :longitude, presence: true, numericality: true
  validates :current_location, inclusion: { in: [true, false] }
end
