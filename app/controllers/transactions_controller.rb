class TransactionsController < ApplicationController
  def index
    @transactions = current_user.transactions
  end

  def create
    # Should also update portfolio/owned shares.
    new_transaction = current_user.transactions.create!(transaction_params)
    update_portfolio(params[:ticker], params[:qty])
    # if new_transaction.save
    # else
    # end
  end

  private
  def transaction_params
    # look into require before permit
    params.permit(:ticker, :qty, :price_per_share)
  end

  def update_portfolio(ticker, qty)
    portfolio = current_user.portfolio

    target_share = OwnedShare.find_by(ticker: ticker, portfolio_id: portfolio.id)

    if target_share
      num_shares_updated = target_share.num_shares + qty
      target_share.update!(num_shares: num_shares_updated)
    else
      OwnedShare.create!(portfolio_id: portfolio.id, num_shares: qty, ticker: ticker)
    end
  end
end
