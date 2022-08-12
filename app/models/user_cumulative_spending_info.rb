class UserCumulativeSpendingInfo < ApplicationRecord
  self.table_name = "user_cumulative_spending_info"

  belongs_to :user

  validates :amount_spent_in_domestic_country, :amount_spent_in_foreign_countries, :transactions_count_info, :current_quarter_info, presence: true
  validates :amount_spent_in_domestic_country, :amount_spent_in_foreign_countries, numericality: { greater_than_or_equal_to: 0 }
end
