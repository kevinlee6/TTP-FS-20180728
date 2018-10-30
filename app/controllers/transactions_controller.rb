class TransactionsController < ApplicationController
  before_action :sanitize_page_params, only: [:create]

  def index
    @transactions = current_user.transactions
  end

  def create
    transaction = Transaction.new(transaction_params)
    ticker = transaction.ticker
    qty = transaction.qty
    price = get_stock_price(ticker)
    can_afford = validate_affordability(qty, price)

    # if price is nil that means cannot afford
    price = validate_affordability(ticker, qty)
    return portfolio if price.nil?
    puts transaction

    if transaction.save
      # current_user.transactions.create!(transaction_params)
      update_portfolio(transaction.ticker, transaction.qty)
    else
    end
  end

  private
  def update_portfolio(ticker, qty)
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

  def validate_affordability(qty, price)
    current_user.cash >= purchase_amt(qty, price)
  end

  def update_balance
    new_balance = current_user.cash - purchase_amt
    current_user.update!(cash: new_balance)
  end

  def transaction_params
    # look into require before permit
    params.permit(:ticker, :qty, :price_per_share)
  end

  def purchase_amt(qty, price)
    qty * price
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
