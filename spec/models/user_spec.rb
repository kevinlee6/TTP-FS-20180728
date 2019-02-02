require 'rails_helper'

RSpec.describe User, type: :model do
  let(:built) {  build(:user) }
  let(:created) { create(:user) }

  describe 'unit tests' do
    context 'account' do
      it 'should be able to be created' do
        saved = built.save
        expect(saved).to eq true
      end

      it 'should validate email' do
        saved = build(:user, email: nil).save
        expect(saved).to eq false
      end

      it 'should validate name' do
        saved = build(:user, name: nil).save
        expect(saved).to eq false
      end

      it 'should validate password' do
        saved = build(:user, password: nil).save
        expect(saved).to eq false
      end
    end

    context 'portfolio' do
      it 'should be created after user creation' do
        portfolio = created.portfolio
        expect(portfolio).to be_a Portfolio
      end
    end

    context 'cash' do
      it 'should be a float' do
        expect(created.cash).to be_a Float
      end

      it 'should start as $5000' do
        expect(created.cash).to eq 5000
      end
    end
  end
end
