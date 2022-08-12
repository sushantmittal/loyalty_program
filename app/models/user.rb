class User < ApplicationRecord
  enum current_tier: { standard_tier: 0, gold_tier: 1, platinum_tier: 2 }, _default: :standard_tier

  EMAIL_REGEXP = /\A[^@\s]+@[^@\s]+\z/

  has_one :cumulative_spending_info, class_name: "UserCumulativeSpendingInfo"
  has_one :loyalty_points_accumulation_info, class_name: "UserLoyaltyPointsAccumulationInfo"
  has_many :transactions, class_name: "UserTransaction"
  has_many :loyalty_points_transactions, class_name: "UserLoyaltyPointsTransaction"
  has_many :rewards, class_name: "UserReward"

  validates :name, :email, :date_of_birth, :country_code, :current_tier, presence: true
  validates :email, uniqueness: true, format: { with: EMAIL_REGEXP, allow_blank: true }
  validates :current_tier, inclusion: { in: current_tiers.keys }

  validate :ensure_date_of_birth_in_the_past

  scope :date_of_birth_in_month, ->(month) { where("extract(month from date_of_birth)= ?", month) }

  private

    def ensure_date_of_birth_in_the_past
      if date_of_birth > Time.current
        errors.add(:date_of_birth, :future)
      end
    end
end
