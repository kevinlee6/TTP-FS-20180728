class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  after_create :build_portfolio
  has_many :transactions
  has_one :portfolio, dependent: :destroy

  validates_presence_of :name
  validates :cash, presence: true, numericality: { greater_than_or_equal_to: 0 }

  private
  def build_portfolio
    Portfolio.create!(user_id: self.id)
  end
end
