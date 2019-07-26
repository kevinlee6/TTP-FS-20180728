module ApplicationHelper
  API_PREFIX = 'https://cloud.iexapis.com/v1/stock'
  API_SUFFIX = "token=#{ENV['API_KEY']}"
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
      link = "#{API}/#{ticker}/price&#{API_SUFFIX}"
      data = HTTParty.get(link).body
      data.to_f.ceil(2)
    rescue Exception => e
      puts e
      nil
    end
  end

  def get_batch_price_and_ohlc(arr)
    return {} if !arr || arr.length < 1
    types = %w[price, ohlc]
    link = "#{API_PREFIX}/market/batch?symbols=#{arr.join(',')}&types=#{types.join}&#{API_SUFFIX}"
    data = HTTParty.get(link).body
    JSON.parse(data)
  end

  def construct_info_hash(owned_shares)
    # batch call only takes in 100 symbols max at a time
    num_tickers_owned = owned_shares.length
    num_api_calls = num_tickers_owned / 100 + 1
    counter = 1
    slice_start = 0

    res = {}

    while counter <= num_api_calls
      slice_end = num_api_calls == counter ?
         num_tickers_owned - 1 :
         counter * 100 - 1

      # might be able to optimize slice and map together
      api_call = get_batch_price_and_ohlc(owned_shares.slice(slice_start..slice_end).map(&:ticker))
      res.merge!(api_call)
      counter += 1
      slice_start += 100
    end

    res
  end
end
