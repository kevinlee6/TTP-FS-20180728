class OwnedShare < ApplicationRecord
  validates :ticker, uniqueness: true, presence: true, length: { in: 1..5 }
  validates :num_shares, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 2**31 }
end
