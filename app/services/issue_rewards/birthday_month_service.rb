class IssueRewards::BirthdayMonthService < IssueRewards::Base
  def perform
    create_reward!(:free_coffee, will_expire_on: Date.current.beginning_of_month.next_month)
  end
end
