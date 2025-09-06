class DashboardController < ApplicationController
  def index
    @accounts = Account.all
    @recent_transactions = Transaction.includes(:account, :category).order(transaction_date: :desc).limit(10)
    @total_balance = Account.sum(:current_balance)
  end
end
