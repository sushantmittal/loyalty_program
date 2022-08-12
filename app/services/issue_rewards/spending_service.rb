class IssueRewards::SpendingService < IssueRewards::Base
  attr_reader :amount_spent_in_domestic_country, :amount_spent_in_domestic_country_changes, :amount_spent_in_foreign_countries,
    :amount_spent_in_foreign_countries_changes, :transactions_count_info_changes, :created_at

  CASH_REBATE_REWARD_RULE = {
    transaction_amount_required: 100,
    transactions_count_required: 10
  }

  FREE_MOVIE_TICKETS_REWARD_RULE = {
    total_spending_required: 1000,
    time_limit: 60
  }

  def initialize(user:, amount_spent_in_domestic_country:, amount_spent_in_domestic_country_changes:, amount_spent_in_foreign_countries:,
    amount_spent_in_foreign_countries_changes:, transactions_count_info_changes:, created_at:
  )
    super(user: user)
    @amount_spent_in_domestic_country = amount_spent_in_domestic_country
    @amount_spent_in_domestic_country_changes = amount_spent_in_domestic_country_changes
    @amount_spent_in_foreign_countries = amount_spent_in_foreign_countries
    @amount_spent_in_foreign_countries_changes = amount_spent_in_foreign_countries_changes
    @transactions_count_info_changes = transactions_count_info_changes
    @created_at = created_at
  end

  def perform
    UserReward.transaction do
      assign_cash_rebate_reward!
      assign_free_movie_tickets_reward!
    end
  end

  private

    def assign_cash_rebate_reward!
      if transactions_count_info_changes
        previous_transaction_amount, previous_transactions_count = transactions_count_info_changes[0]&.flatten
        new_transaction_amount, new_transactions_count = transactions_count_info_changes[1].flatten
        transactions_count_required = CASH_REBATE_REWARD_RULE[:transactions_count_required]

        if(previous_transaction_amount == new_transaction_amount)
          if(previous_transactions_count < transactions_count_required && new_transactions_count >= transactions_count_required)
            create_reward!(:five_percent_cash_rebate)
          end
        elsif(new_transactions_count >= transactions_count_required)
          create_reward!(:five_percent_cash_rebate)
        end
      end
    end

    def assign_free_movie_tickets_reward!
      if amount_spent_in_domestic_country_changes || amount_spent_in_foreign_countries_changes
        new_amount = amount_spent_in_domestic_country + amount_spent_in_foreign_countries
        total_spending_required, time_limit = FREE_MOVIE_TICKETS_REWARD_RULE.values
        
        if(old_amount <= total_spending_required && new_amount > total_spending_required)
          first_transaction_time = user.transactions.order(:created_at).first.created_at

          if (created_at.to_date - first_transaction_time.to_date).to_i <= time_limit
            create_reward!(:free_movie_ticket)
          end
        end
      end
    end

    def old_amount
      if amount_spent_in_domestic_country_changes
        amount_spent_in_domestic_country_changes[0] + amount_spent_in_foreign_countries
      elsif amount_spent_in_foreign_countries_changes
        amount_spent_in_foreign_countries_changes[0] + amount_spent_in_domestic_country
      end
    end
end
