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

  def get_price(ticker)
    begin
      res = HTTParty.get("https://api.iextrading.com/1.0/stock/#{ticker}/price").body
    rescue Exception => e
      puts e
      nil
    end
  end

  def get_price_and_ohlc(ticker)
    begin
      res = HTTParty.get("https://api.iextrading.com/1.0/stock/#{ticker}/batch?types=price,ohlc").body
      res = JSON.parse(res)
      { price: res['price'], open: res['ohlc']['open']['price'] }
    rescue Exception => e
      puts e
      nil
    end
  end
end
