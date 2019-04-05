require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

RSpec.describe "Transaction", type: :request do
  let(:created) { create(:user) }

  describe 'integration test' do
    context 'create' do
      it 'buy' do
        params = {
          ticker: 'AAPL',
          qty: 1,
          price_per_share: 100,
          commit: 'buy'
        }
        login_as(created)
        res = post "/transactions", params: params
        expect { post "/transactions", params: params }.to change(Transaction, :count).by(+1)
      end
    end
  end
end