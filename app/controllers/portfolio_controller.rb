class PortfolioController < ApplicationController
  def index
    # only one portfolio per user at the moment
    @portfolio = current_user.portfolio
    @stock_prices = {} 
    @balance = 0
    @shares = @portfolio.owned_shares

    # looks longer, but O(n) and accounts for balance
    @shares.each do |share|
      ticker = share[:ticker]
      price = get_stock_price(ticker)
      @stock_prices[share.ticker.to_sym] = price 
      @balance += price
    end

    # works, trial 2
    # @stock_prices = get_stock_prices(
    #   @portfolio.owned_shares.map(&:ticker)
    # )

    # doesn't work, trial 1
    # @portfolio.owned_shares.each do |share|
      # # share['curr_price'] = get_stock_price(share.ticker)
      # share.merge(curr_price: get_stock_price(share.ticker))
    # end
  end
end
