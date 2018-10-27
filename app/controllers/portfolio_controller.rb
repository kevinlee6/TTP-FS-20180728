class PortfolioController < ApplicationController
  def show
    @portfolio = current_user.portfolio
  end
end
