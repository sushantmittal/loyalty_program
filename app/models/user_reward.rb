class UserReward < ApplicationRecord
  enum reward: {
    free_coffee: 0,
    five_percent_cash_rebate: 1,
    free_movie_ticket: 2,
    airport_lounge_access: 3
  }

  belongs_to :user

  validates :reward, :quantity, presence: true
  validates :will_expire_on, uniqueness: { scope: [:user_id, :reward] }
  validates :reward, inclusion: { in: rewards.keys }
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
