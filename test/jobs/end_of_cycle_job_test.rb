require "test_helper"

class EndOfCycleJobTest < ActiveJob::TestCase
  setup do
    @user = User.create!(name: "Mark anderson", email: "mark@example.com", country_code: "SG", date_of_birth: Date.strptime("1990-08-20"))
  end

  test "assigns tier based on highest loyalty points accumulated in the last 2 cycles, issues 4 airport lounge access rewards based on tier change and expire the loyalty points after end of a cycle" do
    # First cycle
    @user.loyalty_points_transactions.create!(loyalty_points: 110, created_at: Date.strptime("2019-01-10"))
    @user.loyalty_points_transactions.create!(loyalty_points: 220, created_at: Date.strptime("2019-02-15"))
    @user.loyalty_points_transactions.create!(loyalty_points: 120, created_at: Date.strptime("2019-07-20"))
    @user.loyalty_points_transactions.create!(loyalty_points: 450, created_at: Date.strptime("2019-08-11"))

    EndOfCycleJob.perform_now

    # Assigned standard tier as accumulated loyalty points in this cycle are less than 1000.
    # No Airport lounge access rewards have been issued.
    # Reset the current cycle loyalty points and copied the current cycle loyalty points into last cycle loyalty points which will be used for assigning tier in next cycle.
    assert @user.reload.standard_tier?
    refute @user.rewards.where(reward: :airport_lounge_access).exists?
    assert_equal 0, @user.loyalty_points_accumulation_info.current_cycle_loyalty_points
    assert_equal 900, @user.loyalty_points_accumulation_info.last_cycle_loyalty_points

    # Second cycle
    @user.loyalty_points_transactions.create!(loyalty_points: 100, created_at: Date.strptime("2020-01-20"))
    @user.loyalty_points_transactions.create!(loyalty_points: 400, created_at: Date.strptime("2020-02-14"))
    @user.loyalty_points_transactions.create!(loyalty_points: 200, created_at: Date.strptime("2020-07-10"))
    @user.loyalty_points_transactions.create!(loyalty_points: 300, created_at: Date.strptime("2020-08-15"))

    EndOfCycleJob.perform_now

    # Assigned gold tier as user accumulated 1000 loyalty points in this cycle.
    # 4 Airport lounge access rewards have been issued.
    # Reset the current cycle loyalty points and copied the current cycle loyalty points into last cycle loyalty points which will be used for assigning tier in next cycle.
    assert @user.reload.gold_tier?
    assert_equal 4, @user.rewards.where(reward: :airport_lounge_access, will_expire_on: nil).first.quantity
    assert_equal 0, @user.loyalty_points_accumulation_info.current_cycle_loyalty_points
    assert_equal 1000, @user.loyalty_points_accumulation_info.last_cycle_loyalty_points
  end
end
