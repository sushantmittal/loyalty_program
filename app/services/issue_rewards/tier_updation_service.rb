class IssueRewards::TierUpdationService < IssueRewards::Base
  AIRPORT_LOUNGE_ACCESS_REWARD_QUANTITY = 4

  def perform
    if user.gold_tier? || user.platinum_tier?
      create_reward!(:airport_lounge_access, quantity: AIRPORT_LOUNGE_ACCESS_REWARD_QUANTITY)
    end
  end
end
