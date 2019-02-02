require 'spec_helper'

feature 'External request' do
  describe 'price query' do
    let(:response) do
      uri = URI('https://api.iextrading.com/1.0/stock/AAPL/price')
      Net::HTTP.get(uri)
    end

    it 'queries appl price' do
      expect(response).to be_a String
    end

    it 'can be coerced to float type' do
      expect(response.to_f).to be_a Float
    end
  end
end