u1 = User.create!(
  name: 'Kevin',
  email: 'kevin@gmail.com',
  password: 'password'
)

tickers = %w[AAPL MSFT TSLA GOOG AMZN IBM S B AMD GE]

tickers.each do |ticker|
  u1.portfolio.owned_shares.create!(
    ticker: ticker,
    num_shares: rand(1..20) 
  )
end