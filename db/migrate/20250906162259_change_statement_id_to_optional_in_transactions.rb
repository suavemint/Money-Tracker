class ChangeStatementIdToOptionalInTransactions < ActiveRecord::Migration[8.0]
  def change
    change_column_null :transactions, :statement_id, true
  end
end
