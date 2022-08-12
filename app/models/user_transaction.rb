class UserTransaction < ApplicationRecord
  belongs_to :user

  validates :country_code, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  after_create :update_user_cumulative_spending_info!

  private

    def update_user_cumulative_spending_info!
      UpdateUserCumulativeSpendingInfoService.new(
        user: user,
        country_code: country_code,
        amount: amount,
        created_at: created_at
      ).perform
    end
end
