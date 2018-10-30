module ApplicationHelper
  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def get_stock_price(ticker)
    begin
      IEX::Resources::Price.get(ticker)
    rescue Exception => e
      puts e
      nil
    end
  end

  # might be able to multi-thread series of api calls
  # def get_stock_prices(tickers)
  #   stock_prices = {}

  #   tickers.each do |ticker|
  #     stock_prices[ticker.to_sym] = get_stock_price(ticker)
  #   end
  #   stock_prices
  # end
end
