class PortfolioController < ApplicationController
  def index
    # only one portfolio per user at the moment
    @shares = owned_shares
    @info = construct_info_hash(@shares)
    @balance = 0

    @shares.each do |share|
      ticker = share[:ticker]
      qty = share[:num_shares]
      @balance += @info[ticker]['price'].to_f.floor(2) * qty
    end
  end

  private
  def owned_shares
    current_user.portfolio.owned_shares
  end
end
