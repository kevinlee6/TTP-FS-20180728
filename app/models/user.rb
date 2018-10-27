class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :transactions
  has_one :portfolio, dependent: :destroy

  after_create :build_portfolio

  private
  def build_portfolio
    Portfolio.create!(user_id: self.id)
  end
end
