class TransactionsController < ApplicationController
  before_action :authenticate_user
  before_action :sanitize_page_params

  def index
    @transactions = current_user.transactions
  end

  def create
    new_transaction = current_user.transactions.create!(transaction_params)
    update_portfolio(ticker: params[:ticker], qty: params[:qty])
  end

  private
  def update_portfolio(ticker:, qty:)
    portfolio = current_user.portfolio

    target_share = OwnedShare.find_by(ticker: ticker, portfolio_id: portfolio.id)

    if target_share
      num_shares_updated = target_share.num_shares + qty
      target_share.update!(num_shares: num_shares_updated)
    else
      OwnedShare.create!(portfolio_id: portfolio.id, num_shares: qty, ticker: ticker)
    end
  end

  def transaction_params
    # look into require before permit
    params.permit(:ticker, :qty, :price_per_share)
  end

  def sanitize_page_params
    params[:ticker] = params[:ticker].upcase
    params[:qty] = params[:qty].to_i
    params[:price_per_share] = params[:price_per_share].to_f
  end
end
