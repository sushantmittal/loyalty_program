class IssueRewards::LoyaltyPointsAccumulationService < IssueRewards::Base
  attr_reader :current_month_info_changes

  REQUIRED_LOYALTY_POINTS_FOR_MONTHLY_FREE_COFFEE_REWARD = 100

  def initialize(user:, current_month_info_changes:)
    super(user: user)
    @current_month_info_changes = current_month_info_changes
  end

  def perform
    if current_month_info_changes
      previous_month, previous_loyalty_points = current_month_info_changes[0]&.flatten
      new_month, new_loyalty_points = current_month_info_changes[1].flatten

      if(previous_month == new_month)
        if(
          previous_loyalty_points < REQUIRED_LOYALTY_POINTS_FOR_MONTHLY_FREE_COFFEE_REWARD &&
          new_loyalty_points >= REQUIRED_LOYALTY_POINTS_FOR_MONTHLY_FREE_COFFEE_REWARD
        )
          create_reward!(:free_coffee)
        end
      elsif(new_loyalty_points >= REQUIRED_LOYALTY_POINTS_FOR_MONTHLY_FREE_COFFEE_REWARD)
        create_reward!(:free_coffee)
      end
    end
  end
end
