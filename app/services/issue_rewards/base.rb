class IssueRewards::Base
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  private

    def create_reward!(reward, quantity: 1, will_expire_on: nil)
      reward = user.rewards.where(
        reward: reward,
        will_expire_on: will_expire_on
      ).first_or_initialize

      reward.update!(quantity: (reward.quantity || 0) + quantity)
    end
end
