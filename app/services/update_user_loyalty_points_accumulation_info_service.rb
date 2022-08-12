class UpdateUserLoyaltyPointsAccumulationInfoService
  attr_reader :user, :loyalty_points, :created_at

  def initialize(user:, loyalty_points:, created_at:)
    @user = user
    @loyalty_points = loyalty_points
    @created_at = created_at
  end

  def perform
    loyalty_points_accumulation_info = user.loyalty_points_accumulation_info || user.build_loyalty_points_accumulation_info

    loyalty_points_accumulation_info.update!({
      current_cycle_loyalty_points: loyalty_points_accumulation_info.current_cycle_loyalty_points + loyalty_points,
      current_month_info: current_month_info(loyalty_points_accumulation_info)
    })
  end

  private

    def current_month_info(loyalty_points_accumulation_info)
      current_month = created_at.month.to_s

      previous_amount_of_current_month = loyalty_points_accumulation_info.current_month_info[current_month] || 0

      { current_month => previous_amount_of_current_month + loyalty_points }
    end
end
