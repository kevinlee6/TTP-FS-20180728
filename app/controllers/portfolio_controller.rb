class PortfolioController < ApplicationController
  def index
    # only one portfolio per user at the moment
    @portfolio = current_user.portfolio
    @shares = @portfolio.owned_shares
    @quotes = {}
    @balance = 0

    # looks longer, but O(n) and accounts for balance
    @shares.each do |share|
      ticker = share[:ticker]
      quote = get_quote(ticker)
      if quote
        @quotes[ticker.to_sym] = quote
        @balance += quote.latest_price
      end
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
