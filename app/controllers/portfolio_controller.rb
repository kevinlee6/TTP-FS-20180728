class PortfolioController < ApplicationController
  before_action :get_shares_info, only: [:index, :refresh]
  before_action :calculate_balance, only: [:index, :refresh]

  def index
    # only one portfolio per user at the moment
  end

  def refresh
  end

  def modal
    ticker = params[:ticker]
    @ticker = owned_shares.find_by ticker: ticker
    if @ticker
      @price_per_share = get_price(ticker)
    end
  end

  private
  def owned_shares
    current_user.portfolio.owned_shares
  end

  def get_shares_info
    @shares = owned_shares
    @info = construct_info_hash(@shares)
  end

  def calculate_balance
    @balance = 0

    @shares.each do |share|
      ticker = share[:ticker]
      qty = share[:num_shares]
      @balance += @info[ticker]['price'].to_f.floor(2) * qty
    end
  end
end
