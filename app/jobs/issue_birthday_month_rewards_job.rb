class IssueBirthdayMonthRewardsJob < ApplicationJob
  queue_as :default

  def perform
    User.date_of_birth_in_month(Date.current.month).find_each do |user|
      IssueRewards::BirthdayMonthService.new(user: user).perform
    end
  end
end
