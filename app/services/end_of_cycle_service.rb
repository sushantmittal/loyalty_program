class EndOfCycleService
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def perform
    User.transaction do
      AssignTierService.new(user: user).perform
      IssueRewards::TierUpdationService.new(user: user).perform
      expire_loyalty_points!
    end
  end

  private

    def expire_loyalty_points!
      loyalty_points_accumulation_info = user.loyalty_points_accumulation_info

      loyalty_points_accumulation_info.update!(
        last_cycle_loyalty_points: loyalty_points_accumulation_info.current_cycle_loyalty_points,
        current_cycle_loyalty_points: 0
      )
    end
end
