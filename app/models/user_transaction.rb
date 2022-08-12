class UserTransaction < ApplicationRecord
  belongs_to :user

  validates :country_code, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
end
