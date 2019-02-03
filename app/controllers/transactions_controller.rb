class TransactionsController < ApplicationController
  before_action :sanitize_page_params, only: [:create]
  before_action :choose_method, only: [:create]

  def index
    @transactions = current_user.transactions.order(created_at: :desc)
  end

  def create
    if @method == 'buy'
      validate_params_buy
    elsif @method == 'sell'
      validate_params_sell
    else
      @errors = ['Unknown command: you may only buy or sell shares.']
    end

    if @errors.length > 0
      respond_to do |format|
        format.html { redirect_to portfolio_index_path, alert: @errors.join("\n") }
        format.js
      end
      return @errors
    end
    
    amt = params[:qty]
    action = @method == 'buy' ? 'bought' : 'sold'
    @success = "Transaction successful. You have #{action} #{amt} share#{amt > 1 ? 's' : ''} of #{params[:ticker]}."

    update_portfolio(ticker: params[:ticker], qty: params[:qty])

    transactions = current_user.transactions
    transaction = transactions.new(transaction_params)

    if transaction.save
      @shares = portfolio.owned_shares
      @balance = 0
      @info = construct_info_hash(@shares) 

      @shares.each do |share|
        ticker = share[:ticker]
        qty = share[:num_shares]
        @balance += @info[ticker]['price'].to_f * qty
      end

      @balance = @balance.floor(2)

      respond_to do |format|
        format.html { redirect_to portfolio_index_path, notice: @success }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to portfolio_index_path, notice: 'Error'}
        format.js
      end
    end
  end

  private
  def validate_params_buy
    @errors = []

    # Validate quantity
    unless params[:qty].between?(1, 2**31-1)
      @errors << 'That is not a valid quantity.'
    end

    # Validate existence (ticker)
    @price = get_price(params[:ticker])
    if @price.zero?
      @errors << 'There is no stock with that ticker symbol, or there is a server problem.'
      return @errors
    end

    # Validate price
    frontend_price = params[:price_per_share]
    margin = frontend_price / @price
    # If what the user sees is greater than current pricing, it will go through.
    # Otherwise allow a 5% margin on pricing based on current price.
    within_bounds = margin >= 0.95
    unless within_bounds
      @errors << 'The price listed on your screen did not match the current price. You may need to pull the most current price.'
    end

    unless validate_affordability?
      @errors << 'There is insufficient funds in your account to complete this transaction.'
    end

    if @errors.length > 0
      @errors << 'No transaction has been made.'
    end

    @errors
  end

  def update_portfolio(ticker:, qty:)
    return portfolio if @price.zero?

    # it will be defined if method is sell, from validation; save query
    @target_share = @owned_shares_to_sell || portfolio.owned_shares.find_by(ticker: ticker)

    if @target_share
      qty = @method == 'buy' ? qty : -qty
      num_shares_updated = @target_share.num_shares + qty
      if num_shares_updated.zero?
        @target_share.destroy
      else
        @target_share.update!(num_shares: num_shares_updated)
      end
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

  def validate_params_sell
    @errors = []
    @owned_shares_to_sell = portfolio.owned_shares.find_by ticker: params[:ticker]

    if !@owned_shares_to_sell
      @errors << 'You do not own this share. Try refreshing the page.'
      return
    end

    # Validate quantity
    unless params[:qty].between?(1, @owned_shares_to_sell.num_shares)
      @errors << 'You do not own that many shares.'
    end

    # Validate existence (ticker)
    @price = get_price(params[:ticker])
    if @price.zero?
      @errors << 'There is no stock with that ticker symbol, or there is a server problem.'
      return @errors
    end

    # Validate price
    frontend_price = params[:price_per_share]
    margin = frontend_price / @price
    # If what the user sees is greater than current pricing, it will go through.
    # Otherwise allow a 5% margin on pricing based on current price.
    within_bounds = margin >= 0.95
    unless within_bounds
      @errors << 'The price listed on your screen did not match the current price. You may need to pull the most current price.'
    end

    if @errors.length > 0
      @errors << 'No transaction has been made.'
    end

    @errors
  end

  def validate_affordability?
    current_user.cash >= transaction_amt
  end

  def update_balance
    new_balance = current_user.cash - transaction_amt
    current_user.update!(cash: new_balance)
  end

  def transaction_params
    params.permit(:ticker, :qty, :price_per_share, :method)
  end

  def transaction_amt
    qty = @method == 'buy' ? params[:qty] : -params[:qty]
    qty * @price
  end

  def sanitize_page_params
    params[:ticker].upcase!
    params[:qty] = params[:qty].to_i
    params[:price_per_share] = params[:price_per_share].to_f
    params[:method] = params[:commit].downcase
  end

  def choose_method
    method = params[:method]
    if method == 'buy'
      @method = 'buy'
    elsif method == 'sell'
      @method = 'sell'
    else
      @method = nil
    end
  end

  def portfolio
    current_user.portfolio
  end
end
