class Transaction < ApplicationRecord
  belongs_to :user

  validates :ticker, uniqueness: true, presence: true, length: { in: 1..5 }
  validates :qty, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 2**31 }
  validates :price_per_share, presence: true, numericality: { greater_than: 0, less_than: 2**31 }
end
