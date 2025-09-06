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
    @transaction.account = Account.find(params[:account_id]) if params[:account_id]
    @transaction.category = Category.find(params[:transaction][:category_id]) if params[:transaction][:category_id].present?
    if @transaction.save
      redirect_to @transaction
    else
      render :new
    end
  end

  def update
    @transaction = Transaction.find(params[:id])
    @transaction.assign_attributes(transaction_params)
    @transaction.category = Category.find(params[:transaction][:category_id]) if params[:transaction][:category_id].present?
    if @transaction.save
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
    params.require(:transaction).permit(:amount, :description, :transaction_date, :transaction_type)
  end
end
