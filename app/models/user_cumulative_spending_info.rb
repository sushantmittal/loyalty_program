class UserCumulativeSpendingInfo < ApplicationRecord
  self.table_name = "user_cumulative_spending_info"

  belongs_to :user

  validates :amount_spent_in_domestic_country, :amount_spent_in_foreign_countries, :transactions_count_info, :current_quarter_info, presence: true
  validates :amount_spent_in_domestic_country, :amount_spent_in_foreign_countries, numericality: { greater_than_or_equal_to: 0 }

  after_save :assign_loyalty_points, if: -> {
    saved_change_to_amount_spent_in_domestic_country? ||
    saved_change_to_amount_spent_in_foreign_countries? ||
    saved_change_to_current_quarter_info?
  }

  after_save :issue_rewards, if: -> {
    saved_change_to_amount_spent_in_domestic_country? ||
    saved_change_to_amount_spent_in_foreign_countries? ||
    saved_change_to_transactions_count_info?
  }

  private

    def assign_loyalty_points
      AssignLoyaltyPointsService.new(
        user: user,
        amount_spent_in_domestic_country_changes: saved_change_to_amount_spent_in_domestic_country,
        amount_spent_in_foreign_countries_changes: saved_change_to_amount_spent_in_foreign_countries,
        current_quarter_info_changes: saved_change_to_current_quarter_info
      ).perform
    end

    def issue_rewards
      IssueRewards::SpendingService.new(
        user: user,
        amount_spent_in_domestic_country: amount_spent_in_domestic_country,
        amount_spent_in_domestic_country_changes: saved_change_to_amount_spent_in_domestic_country,
        amount_spent_in_foreign_countries: amount_spent_in_foreign_countries,
        amount_spent_in_foreign_countries_changes: saved_change_to_amount_spent_in_foreign_countries,
        transactions_count_info_changes: saved_change_to_transactions_count_info,
        created_at: created_at
      ).perform
    end
end
