require "test_helper"

class UserTransactionRulesTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Mark anderson", email: "mark@example.com", country_code: "SG", date_of_birth: Date.strptime("1990-10-20"))
  end

  test "assigns 10 points for every $100 the end user spends in domestic country, assigns 20 points for every $100 the end user spends in foreign countries and assigns 100 quarterly bonus points to users who have spending greater than $2000 in that quarter" do
    @user.transactions.create!(country_code: "SG", amount: 110, created_at: Date.strptime("2022-01-10"))
    @user.transactions.create!(country_code: "US", amount: 420, created_at: Date.strptime("2022-02-15"))
    @user.transactions.create!(country_code: "IN", amount: 650, created_at: Date.strptime("2022-02-20"))
    @user.transactions.create!(country_code: "SG", amount: 840, created_at: Date.strptime("2022-03-11"))
    @user.transactions.create!(country_code: "SG", amount: 120, created_at: Date.strptime("2022-04-05"))
    @user.transactions.create!(country_code: "SG", amount: 320, created_at: Date.strptime("2022-04-06"))
    @user.transactions.create!(country_code: "SG", amount: 660, created_at: Date.strptime("2022-05-20"))
    @user.transactions.create!(country_code: "US", amount: 900, created_at: Date.strptime("2022-06-09"))
    @user.transactions.create!(country_code: "IN", amount: 570, created_at: Date.strptime("2022-07-17"))
    @user.transactions.create!(country_code: "SG", amount: 650, created_at: Date.strptime("2022-08-11"))
    @user.transactions.create!(country_code: "SG", amount: 550, created_at: Date.strptime("2022-09-02"))
    @user.transactions.create!(country_code: "SG", amount: 420, created_at: Date.strptime("2022-09-08"))

    # 360 loyalty points have been assigned for domestic country spendings.
    # 500 loyalty points have been assigned for foreign countries spendings.
    # 200 quarterly bonus points have been assigned for spending greater than $2000 in first and third quarter.
    assert_equal 1060, @user.loyalty_points_accumulation_info.current_cycle_loyalty_points
  end

  test "issues five percent cash rebate reward if user has 10 or more transactions that have an amount > $100" do
    user2 = User.create!(name: "John sattler", email: "john@example.com", country_code: "SG", date_of_birth: Date.strptime("1989-11-15"))

    @user.transactions.create!(country_code: "SG", amount: 110)
    @user.transactions.create!(country_code: "US", amount: 50)
    @user.transactions.create!(country_code: "IN", amount: 100)
    @user.transactions.create!(country_code: "SG", amount: 120)
    @user.transactions.create!(country_code: "SG", amount: 130)
    @user.transactions.create!(country_code: "SG", amount: 140)
    @user.transactions.create!(country_code: "SG", amount: 200)
    @user.transactions.create!(country_code: "US", amount: 210)
    @user.transactions.create!(country_code: "IN", amount: 160)
    @user.transactions.create!(country_code: "SG", amount: 110)
    @user.transactions.create!(country_code: "SG", amount: 200)
    @user.transactions.create!(country_code: "SG", amount: 220)

    user2.transactions.create!(country_code: "SG", amount: 110)
    user2.transactions.create!(country_code: "US", amount: 50)
    user2.transactions.create!(country_code: "IN", amount: 100)
    user2.transactions.create!(country_code: "SG", amount: 90)
    user2.transactions.create!(country_code: "SG", amount: 130)
    user2.transactions.create!(country_code: "SG", amount: 140)
    user2.transactions.create!(country_code: "SG", amount: 200)
    user2.transactions.create!(country_code: "US", amount: 210)
    user2.transactions.create!(country_code: "IN", amount: 160)
    user2.transactions.create!(country_code: "SG", amount: 110)
    user2.transactions.create!(country_code: "SG", amount: 200)
    user2.transactions.create!(country_code: "SG", amount: 220)

    # five percent cash rebate reward has been issued to @user as this user has 10 transactions of amount > $100.
    # five percent cash rebate reward has not been issued to user2 as this user has less than 10 transactions of amount > $100.
    assert_equal 1, @user.rewards.where(reward: :five_percent_cash_rebate, will_expire_on: nil).first.quantity
    refute user2.rewards.where(reward: :five_percent_cash_rebate).exists?
  end

  test "issues free movie ticket reward if user's spending is > $1000 within 60 days of first transaction" do
    user2 = User.create!(name: "John sattler", email: "john@example.com", country_code: "SG", date_of_birth: Date.strptime("1989-11-15"))

    Timecop.freeze(Date.strptime("2022-08-15")) do
      @user.transactions.create!(country_code: "SG", amount: 110, created_at: Date.strptime("2022-06-16"))
      @user.transactions.create!(country_code: "US", amount: 200, created_at: Date.strptime("2022-06-25"))
      @user.transactions.create!(country_code: "IN", amount: 450, created_at: Date.strptime("2022-07-10"))
      @user.transactions.create!(country_code: "SG", amount: 520, created_at: Date.strptime("2022-08-15"))

      user2.transactions.create!(country_code: "SG", amount: 110, created_at: Date.strptime("2022-06-15"))
      user2.transactions.create!(country_code: "US", amount: 200, created_at: Date.strptime("2022-06-25"))
      user2.transactions.create!(country_code: "IN", amount: 450, created_at: Date.strptime("2022-07-10"))
      user2.transactions.create!(country_code: "SG", amount: 520, created_at: Date.strptime("2022-08-15"))
    end

    # free movie ticket reward has been issued to @user as this user's spending is > $1000 within 60 days of first transaction.
    # free movie ticket reward has not been issued to user2 as this user's spending is > $1000 but after 60 days of first transaction.
    assert_equal 1, @user.rewards.where(reward: :free_movie_ticket, will_expire_on: nil).first.quantity
    refute user2.rewards.where(reward: :free_movie_ticket).exists?
  end
end
