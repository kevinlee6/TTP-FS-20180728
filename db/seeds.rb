u1 = User.create!(
  name: 'Kevin',
  email: 'kevin@gmail.com',
  password: 'password'
)

u1.portfolio.owned_shares.create!(
  ticker: 'AAPL',
  num_shares: 12
)