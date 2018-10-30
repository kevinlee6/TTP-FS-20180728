u1 = User.create!(
  name: 'Kevin',
  email: 'kevin@gmail.com',
  password: 'password',
  cash: 50000
)

tickers = %w[AAPL MSFT TSLA GOOG AMZN IBM S B AMD GE]

def get_stock_price(ticker)
  begin
    IEX::Resources::Price.get(ticker)
  rescue Exception => e
    puts e
    nil
  end
end

tickers.each do |ticker|
  price = get_stock_price(ticker)
  
  if price
    u1.transactions.create!(
      ticker: ticker,
      qty: rand(1..2),
      price_per_share: price 
    )
  end
end