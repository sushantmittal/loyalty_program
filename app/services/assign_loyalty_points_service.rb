class AssignLoyaltyPointsService
  attr_reader :user, :amount_spent_in_domestic_country_changes, :amount_spent_in_foreign_countries_changes, :current_quarter_info_changes

  LOYALTY_POINTS_RULE_DATA = {
    domestic_country_spending: { amount_required_to_spend: 100, assign_loyalty_points: 10 },
    foreign_countries_spending: { amount_required_to_spend: 100, assign_loyalty_points: 20 },
    quarterly_bonus: { amount_required_to_spend: 2000, assign_loyalty_points: 100 }
  }

  def initialize(user:, amount_spent_in_domestic_country_changes:, amount_spent_in_foreign_countries_changes:, current_quarter_info_changes:)
    @user = user
    @amount_spent_in_domestic_country_changes = amount_spent_in_domestic_country_changes
    @amount_spent_in_foreign_countries_changes = amount_spent_in_foreign_countries_changes
    @current_quarter_info_changes = current_quarter_info_changes
  end

  def perform
    UserLoyaltyPointsTransaction.transaction do
      assign_loyalty_points_on_domestic_country_spending!
      assign_loyalty_points_on_foreign_countries_spending!
      assign_quarterly_loyalty_points_bonus!
    end
  end

  private

    def assign_loyalty_points_on_domestic_country_spending!
      assign_loyalty_points_on_country_spending!(
        amount_spent_in_domestic_country_changes,
        LOYALTY_POINTS_RULE_DATA[:domestic_country_spending],
        "These loyalty points have been assigned because of spending in domestic country."
      )
    end

    def assign_loyalty_points_on_foreign_countries_spending!
      assign_loyalty_points_on_country_spending!(
        amount_spent_in_foreign_countries_changes,
        LOYALTY_POINTS_RULE_DATA[:foreign_countries_spending],
        "These loyalty points have been assigned because of spending in foreign countries."
      )
    end

    def assign_loyalty_points_on_country_spending!(amount_spent_changes, points_rule_data, description)
      if amount_spent_changes
        amount_required_to_spend, assign_loyalty_points = points_rule_data.values

        total_loyalty_points_to_assign = ((amount_spent_changes[1]/amount_required_to_spend) -
          (amount_spent_changes[0]/amount_required_to_spend)) * assign_loyalty_points

        create_loyalty_points_transaction!(total_loyalty_points_to_assign, description) if total_loyalty_points_to_assign > 0
      end
    end

    def assign_quarterly_loyalty_points_bonus!
      if current_quarter_info_changes
        previous_quarter, previous_amount = current_quarter_info_changes[0]&.flatten
        new_quarter, new_amount = current_quarter_info_changes[1].flatten
        amount_required_to_spend, assign_loyalty_points = LOYALTY_POINTS_RULE_DATA[:quarterly_bonus].values

        if(previous_quarter == new_quarter)
          if(previous_amount <= amount_required_to_spend && new_amount > amount_required_to_spend)
            create_loyalty_points_transaction!(
              assign_loyalty_points,
              "These loyalty points have been assigned as quarterly bonus because spending is greater than #{amount_required_to_spend}."
            )
          end
        elsif(new_amount > amount_required_to_spend)
          create_loyalty_points_transaction!(
            assign_loyalty_points,
            "These loyalty points have been assigned as quarterly bonus because spending is greater than #{amount_required_to_spend}."
          )
        end
      end
    end

    def create_loyalty_points_transaction!(loyalty_points, description)
      user.loyalty_points_transactions.create!(
        loyalty_points: loyalty_points,
        description: description
      )
    end
end
