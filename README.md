# StockDock

Manage your stock market portfolio. 

## Features

- Utilizes [IEX API](https://iextrading.com/developer/)
  - Pull latest stock pricing and opening price
- Create an account with an email and password
- Starting balance of $5000
- Search by stock symbol to obtain up-to-date pricing
- Purchase stocks if there are available funds
- View list of all transactions
- View portfolio, which houses all owned shares
  - Owned shares are color-coded to indicate daily performance
    - Daily performance (change) is calculated by current pricing - opening price
    - Green text indicates positive change
    - Grey text indicates no change
    - Red text indicates negative change
- DataTables library provides server-sided pagination, in-table search, and sortable columns

## Tech Stack

- Ruby on Rails
- Bootstrap
- JQuery
- DataTables

## Database Design

Database was designed around 4 models/tables.

- User
- Portfolio
- Owned Shares
- Transactions

The chain of command/ownership is illustrated

## Notable Gems

- Devise: User authentication
- HTTParty: Interact with IEX API
