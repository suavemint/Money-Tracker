class Account < ApplicationRecord
  has_many :statements, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :name, presence: true
  validates :account_type, presence: true
  validates :institution, presence: true
  validates :current_balance, presence: true, numericality: true

  ACCOUNT_TYPES = %w[checking savings credit_card investment loan other].freeze

  validates :account_type, inclusion: { in: ACCOUNT_TYPES }

  def balance_as_of(date)
    transactions.where("transaction_date <= ?", date).sum(:amount)
  end
end
