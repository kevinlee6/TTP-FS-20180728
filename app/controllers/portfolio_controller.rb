class PortfolioController < ApplicationController
  def index
    # only one portfolio per user at the moment
    portfolio = current_user.portfolio
    @shares = portfolio.owned_shares
    @balance = 0

    @info = get_batch_price_and_ohlc(@shares.map(&:ticker))

    @shares.each do |share|
      ticker = share[:ticker]
      qty = share[:num_shares]
      @balance += @info[ticker]['price'].to_f.floor(2) * qty
    end
  end
end
