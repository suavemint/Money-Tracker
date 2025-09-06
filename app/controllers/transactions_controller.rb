class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.includes(:account, :category).all
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  def new
    @transaction = Transaction.new
  end

  def edit
    @transaction = Transaction.find(params[:id])
  end

  def create
    @transaction = Transaction.new(transaction_params)
    if @transaction.save
      redirect_to @transaction
    else
      render :new
    end
  end

  def update
    @transaction = Transaction.find(params[:id])
    if @transaction.update(transaction_params)
      redirect_to @transaction
    else
      render :edit
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy
    redirect_to transactions_url
  end

  private

  def transaction_params
    params.require(:transaction).permit(:account_id, :category_id, :amount, :description, :transaction_date, :transaction_type)
  end
end
