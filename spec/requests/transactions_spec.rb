require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

RSpec.describe "Transaction", type: :request do
  let!(:current_user) { login_as(create(:user)) }

  describe 'integration test' do
    it 'index' do
      expect(get "/transactions").to eq(200)
    end

    context 'create' do
      it 'buy then sell' do
        PARAMS = {
          ticker: 'AAPL',
          qty: 1,
          price_per_share: 100,
          commit: 'buy'
        }
        expect { post "/transactions", params: PARAMS }.to change(Transaction, :count).by(+1)
        expect { post "/transactions", params: PARAMS.merge(commit: 'sell') }.to change(Transaction, :count).by(+1)
      end
    end
  end
end