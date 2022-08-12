require "test_helper"

class IssueBirthdayMonthRewardsJobTest < ActiveJob::TestCase
  test "issues a free coffee reward to all users who have birthday in current month." do
    Timecop.freeze(Date.strptime("2022-08-12")) do
      user1 = User.create!(name: "Mark anderson", email: "mark@example.com", country_code: "SG", date_of_birth: Date.strptime("1990-08-20"))
      user2 = User.create!(name: "John sattler", email: "john@example.com", country_code: "IN", date_of_birth: Date.strptime("1990-09-10"))
      user3 = User.create!(name: "Alejandro smith", email: "alejandro@example.com", country_code: "SG", date_of_birth: Date.strptime("1989-08-05"))

      IssueBirthdayMonthRewardsJob.perform_now

      # Free coffee rewards have been issued to user1 and user3 because they have birthday in current month.
      assert_equal 1, user1.rewards.where(reward: :free_coffee, will_expire_on: Date.strptime("2022-09-01")).first.quantity
      refute user2.rewards.where(reward: :free_coffee).exists?
      assert_equal 1, user3.rewards.where(reward: :free_coffee, will_expire_on: Date.strptime("2022-09-01")).first.quantity
    end
  end
end
