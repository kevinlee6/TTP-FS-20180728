class TransactionsController < ApplicationController
  before_action :sanitize_page_params, only: [:create]

  def index
    @transactions = current_user.transactions.order(created_at: :desc)
  end

  def create
    can_afford = validate_affordability
    unless can_afford
      return @error = can_afford.nil? ?
        'There is no stock with that ticker symbol, or there is a server problem.' :
        'You have insufficient funds to make that purchase.'
    end
    new_transaction = current_user.transactions.create!(transaction_params)
    update_portfolio(ticker: params[:ticker], qty: params[:qty])
    new_transaction
  end

  private
  def update_portfolio(ticker:, qty:)
    # silent error, fix later
    return portfolio if @stock_price.nil?
    target_share = OwnedShare.find_by(ticker: ticker, portfolio_id: portfolio.id)
    if target_share
      num_shares_updated = target_share.num_shares + qty
      target_share.update!(num_shares: num_shares_updated)
    else
      OwnedShare.create!(
        portfolio_id: portfolio.id,
        num_shares: qty,
        ticker: ticker
      )
    end
    update_balance
    portfolio
  end

  def validate_affordability
    @stock_price = get_stock_price(params[:ticker])
    return nil if @stock_price.nil?
    current_user.cash >= purchase_amt
  end

  def update_balance
    new_balance = current_user.cash - purchase_amt
    current_user.update!(cash: new_balance)
  end

  def transaction_params
    # look into require before permit
    params.permit(:ticker, :qty, :price_per_share)
  end

  def purchase_amt
    # params[:qty] * params[:price_per_share]
    params[:qty] * @stock_price
  end

  def sanitize_page_params
    params[:ticker] = params[:ticker].upcase
    params[:qty] = params[:qty].to_i
    params[:price_per_share] = params[:price_per_share].to_f
  end

  def portfolio
    current_user.portfolio
  end
end
