class StatementsController < ApplicationController
  def index
    @statements = Statement.includes(:account).all
  end

  def show
    @statement = Statement.find(params[:id])
  end

  def new
    @statement = Statement.new
  end

  def create
    @statement = Statement.new(statement_params)
    @statement.account = Account.find(params[:account_id]) if params[:account_id]
    if @statement.save
      redirect_to @statement
    else
      render :new
    end
  end

  def destroy
    @statement = Statement.find(params[:id])
    @statement.destroy
    redirect_to statements_url
  end

  private

  def statement_params
    params.require(:statement).permit(:filename, :upload_date, :file)
  end
end
