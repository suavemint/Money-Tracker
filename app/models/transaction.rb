class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :category, optional: true
  belongs_to :statement, optional: true

  validates :amount, presence: true, numericality: true
  validates :description, presence: true
  validates :transaction_date, presence: true
  validates :transaction_type, presence: true, inclusion: { in: %w[credit debit] }

  scope :income, -> { where("amount > 0") }
  scope :expenses, -> { where("amount < 0") }
  scope :for_period, ->(start_date, end_date) { where(transaction_date: start_date..end_date) }
  scope :by_category, ->(category) { where(category: category) }

  def income?
    amount > 0
  end

  def expense?
    amount < 0
  end

  def amount_abs
    amount.abs
  end
end
