API_PREFIX = 'https://cloud.iexapis.com/v1/stock'
API_SUFFIX = "token=#{ENV['API_KEY']}"
def get_batch_price(arr)
  link = "#{API_PREFIX}/market/batch?symbols=#{arr.join(',')}&types=price&#{API_SUFFIX}"
  data = HTTParty.get(link).body
  JSON.parse(data)
end

tickers = %w[AAPL MSFT TSLA GOOG AMZN IBM S B AMD GE]
prices = get_batch_price(tickers)

user = User.new(
  name: 'Kevin',
  email: 'kevin@gmail.com',
  password: 'password',
  cash: 50000
)

if user.save
  u1 = User.last
  tickers.each do |ticker|
    qty = rand(1..21)
    u1.transactions.create!(
      ticker: ticker,
      qty: qty,
      price_per_share: prices[ticker]['price'].to_f.floor(2), 
      method: 'buy'
    )
    u1.portfolio.owned_shares.create!(
      ticker: ticker,
      num_shares: qty
    )
  end
end
