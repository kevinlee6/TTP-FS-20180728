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
      HTTParty.get("https://api.iextrading.com/1.0/stock/#{ticker}/price").body.to_i
    rescue Exception => e
      puts e
      nil
    end
  end

  def get_batch_price_and_ohlc(arr)
    JSON.parse(HTTParty.get("https://api.iextrading.com/1.0/stock/market/batch?symbols=#{arr.join(',')}&types=price,ohlc").body)
  end
end
