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
        'You have insufficient funds to make this purchase.'
    end

    update_portfolio(ticker: params[:ticker], qty: params[:qty])
    current_user.transactions.create!(transaction_params)
    # portfolio = current_user.portfolio
    # @shares = portfolio.owned_shares
    # @quotes = {}
    # @balance = 0

    # @shares.each do |share|
    #   ticker = share[:ticker]
    #   quote = get_quote(ticker)
    #   if quote
    #     qty = share[:num_shares]
    #     @quotes[ticker.to_sym] = quote
    #     @balance += quote.latest_price * qty 
    #   end
    # end
  end

  private
  def update_portfolio(ticker:, qty:)
    # silent error, fix later
    return portfolio if @stock_price.nil?
    @target_share = portfolio.owned_shares.find_by(ticker: ticker)
    if @target_share
      num_shares_updated = @target_share.num_shares + qty
      @target_share.update!(num_shares: num_shares_updated)
    else
      @target_share = 
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
    @price_and_open = get_price_and_ohlc(params[:ticker])
    return nil if @price_and_open.nil?
    @stock_price = @price_and_open[:price]
    current_user.cash >= purchase_amt
  end

  def update_balance
    new_balance = current_user.cash - purchase_amt
    current_user.update!(cash: new_balance)
  end

  def transaction_params
    params.permit(:ticker, :qty, :price_per_share)
  end

  def purchase_amt
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
