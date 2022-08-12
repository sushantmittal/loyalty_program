require "test_helper"

class UserLoyaltyPointsTransactionRulesTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(name: "Mark anderson", email: "mark@example.com", country_code: "SG", date_of_birth: Date.strptime("1990-10-20"))
  end

  test "issues free coffee reward if end user accumulates 100 points in one calendar month." do
    @user.loyalty_points_transactions.create!(loyalty_points: 50, created_at: Date.strptime("20-08-2022-08-20"))
    @user.loyalty_points_transactions.create!(loyalty_points: 60, created_at: Date.strptime("22-08-2022-08-22"))
    @user.loyalty_points_transactions.create!(loyalty_points: 30, created_at: Date.strptime("15-09-2022-09-15"))
    @user.loyalty_points_transactions.create!(loyalty_points: 20, created_at: Date.strptime("21-09-2022-09-21"))
    @user.loyalty_points_transactions.create!(loyalty_points: 40, created_at: Date.strptime("23-09-2022-09-23"))
    @user.loyalty_points_transactions.create!(loyalty_points: 40, created_at: Date.strptime("16-10-2022-10-16"))
    @user.loyalty_points_transactions.create!(loyalty_points: 30, created_at: Date.strptime("20-10-2022-10-20"))
    @user.loyalty_points_transactions.create!(loyalty_points: 50, created_at: Date.strptime("25-10-2022-10-25"))

    # Free coffee rewards have been issued for months 8 and 10 as user accumulated 100 points in these months.
    assert_equal 2, @user.rewards.where(reward: :free_coffee, will_expire_on: nil).first.quantity
  end
end
