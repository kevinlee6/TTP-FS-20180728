class PortfolioController < ApplicationController
  def index
    # only one portfolio per user at the moment
    portfolio = current_user.portfolio
    @shares = portfolio.owned_shares
    @info = {}
    @balance = 0

    # looks longer, but O(n) and accounts for balance
    @shares.each do |share|
      ticker = share[:ticker]
      price_and_ohlc = get_price_and_ohlc(ticker)
      price = price_and_ohlc[:price]
      if price
        qty = share[:num_shares]
        @info[ticker.to_sym] = price_and_ohlc
        @balance += price * qty 
      end
    end

    # respond_to do |format|
    #   format.html
    #   format.json { render json: {shares: @shares, quotes: @quotes } }
    # enduuu

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
