class UserLoyaltyPointsAccumulationInfo < ApplicationRecord
  self.table_name = "user_loyalty_points_accumulation_info"

  belongs_to :user

  validates :current_cycle_loyalty_points, :last_cycle_loyalty_points, :current_month_info, presence: true
  validates :current_cycle_loyalty_points, :last_cycle_loyalty_points, numericality: { greater_than_or_equal_to: 0 }
end
