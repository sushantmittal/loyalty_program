class UserLoyaltyPointsTransaction < ApplicationRecord
  belongs_to :user

  validates :loyalty_points, presence: true, numericality: { other_than: 0 }
end
