class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :statement, null: false, foreign_key: true
      t.decimal :amount
      t.string :description
      t.date :transaction_date
      t.string :transaction_type

      t.timestamps
    end
  end
end
