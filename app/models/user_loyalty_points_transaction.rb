class UserLoyaltyPointsTransaction < ApplicationRecord
  belongs_to :user

  validates :loyalty_points, presence: true, numericality: { other_than: 0 }

  after_create :update_user_loyalty_points_accumulation_info!

  private

    def update_user_loyalty_points_accumulation_info!
      UpdateUserLoyaltyPointsAccumulationInfoService.new(
        user: user,
        loyalty_points: loyalty_points,
        created_at: created_at
      ).perform
    end
end
