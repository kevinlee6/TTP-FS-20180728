# [StockDock](https://stockdock.herokuapp.com/Manage)

Manage your stock market portfolio. 

## Demo account

- Email: kevin@gmail.com
- Password: password

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
- DataTables library provides pagination, in-table search, and sortable columns

## Tech Stack

- Ruby on Rails
- Bootstrap
- JQuery

## Database Design

Database was designed around 4 models/tables.

- User
- Portfolio
- Owned Shares
- Transactions

The chain of command/ownership can be illustrated by:

- User > Portfolio > Owned Shares
- User > Transactions

A User has one Portfolio which is automatically created upon user creation. A Portfolio can have 0 or more Owned Shares. A User can also have one or more Transactions.

The Transactions table is capable of calculating all the Owned Shares of a User. But because Transactions are never deleted (as opposed to Owned Shares, which can be bought and later sold), along with potentially high volume of Transactions as the app scales, the cost of (re)calculating Owned Shares can get expensive. In my case, I traded space (a Portfolio table) for potential time savings. The Transaction controller is the mediator between a User's cash balance and a Portfolio's Owned Shares. When a transaction is created/successful, the Owned Shares and User's balance is adjusted accordingly.

The reasoning behind a Portfolio table, as opposed to a direct relationship between User and Owned Shares, is because a User can potentially have more than one Portfolio to separate and organize their holdings. It may be implemented in the future.

The price of a stock is pulled on the front-end so the user can view it before taking action. The price is also pulled on the back-end to validate if the current price is close to what the user saw. I chose a 3% margin since the stock market is constantly in flux during the time it's open. To mitigate this in the future, I could implement small fees to offset the difference along with a session timeout if idle for a certain period of time. 

## Notable Gems/Libaries

- Devise: User authentication and associations
- HTTParty: Interact with IEX API to get current and opening price
- DataTables: JavaScript library which provided features such as pagination, in-table search, and sortable columns
