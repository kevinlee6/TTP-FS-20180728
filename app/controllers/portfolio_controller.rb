class PortfolioController < ApplicationController
  def index
    # only one portfolio per user
    @portfolio = current_user.portfolio
    @stock_prices = get_stock_prices(
      @portfolio.owned_shares.map(&:ticker)
    )

    # @portfolio.owned_shares.each do |share|
      # # share['curr_price'] = get_stock_price(share.ticker)
      # share.merge(curr_price: get_stock_price(share.ticker))
    # end
  end
end
