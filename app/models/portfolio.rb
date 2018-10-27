class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :owned_shares
end
