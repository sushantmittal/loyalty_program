class AssignTierService
  attr_reader :user

  REQUIRED_LOYALTY_POINTS_FOR_TIERS = { standard_tier: 0, gold_tier: 1000, platinum_tier: 5000 }

  def initialize(user:)
    @user = user
  end

  def perform
    user_loyalty_points_accumulation_info = user.loyalty_points_accumulation_info

    highest_loyalty_points_in_last_cycles = [
      user_loyalty_points_accumulation_info.current_cycle_loyalty_points, user_loyalty_points_accumulation_info.last_cycle_loyalty_points
    ].max

    tier = if highest_loyalty_points_in_last_cycles >= REQUIRED_LOYALTY_POINTS_FOR_TIERS[:platinum_tier]
      :platinum_tier
    elsif highest_loyalty_points_in_last_cycles >= REQUIRED_LOYALTY_POINTS_FOR_TIERS[:gold_tier]
      :gold_tier
    else
      :standard_tier
    end

    user.update!(current_tier: tier)
  end
end
