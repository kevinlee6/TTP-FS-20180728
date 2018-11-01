class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    # Homepage/Landing
    return if !current_user
    transactions = current_user.transactions

    # Show last 5 transactions
    @transactions = transactions.last(5).reverse()
  end
end
