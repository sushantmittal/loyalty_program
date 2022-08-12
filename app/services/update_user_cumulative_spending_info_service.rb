class UpdateUserCumulativeSpendingInfoService
  attr_reader :user, :country_code, :amount, :created_at

  def initialize(user:, country_code:, amount:, created_at:)
    @user = user
    @country_code = country_code
    @amount = amount
    @created_at = created_at
  end

  def perform
    cumulative_spending_info = user.cumulative_spending_info || user.build_cumulative_spending_info

    attributes_to_update = countries_spending_attributes(cumulative_spending_info)
    attributes_to_update
      .merge!(transactions_count_info(cumulative_spending_info))
      .merge!(current_quarter_info(cumulative_spending_info))

    cumulative_spending_info.update!(attributes_to_update)
  end

  private

    def amount_spent_in_domestic_country?
      user.country_code == country_code
    end

    def countries_spending_attributes(cumulative_spending_info)
      if(amount_spent_in_domestic_country?)
        { amount_spent_in_domestic_country: cumulative_spending_info.amount_spent_in_domestic_country + amount }
      else
        { amount_spent_in_foreign_countries: cumulative_spending_info.amount_spent_in_foreign_countries + amount }
      end
    end

    def transactions_count_info(cumulative_spending_info)
      transaction_amount_required = IssueRewards::SpendingService::CASH_REBATE_REWARD_RULE[:transaction_amount_required].to_s
      previous_transactions_count = cumulative_spending_info.transactions_count_info[transaction_amount_required] || 0

      if amount > transaction_amount_required.to_i
        { transactions_count_info: { transaction_amount_required => previous_transactions_count + 1 }}
      else
        { transactions_count_info: { transaction_amount_required => previous_transactions_count }}
      end
    end

    def current_quarter_info(cumulative_spending_info)
      current_quarter = (((created_at.month - 1) / 3) + 1).to_s

      previous_amount_of_current_quarter = cumulative_spending_info.current_quarter_info[current_quarter] || 0

      { current_quarter_info: { current_quarter => previous_amount_of_current_quarter + amount }}
    end
end
