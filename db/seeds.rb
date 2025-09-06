# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create default categories
categories = [
  { name: "Groceries", color: "#4CAF50", description: "Food and grocery shopping" },
  { name: "Transportation", color: "#2196F3", description: "Gas, public transport, parking" },
  { name: "Entertainment", color: "#FF9800", description: "Movies, games, dining out" },
  { name: "Utilities", color: "#9C27B0", description: "Electricity, water, internet, phone" },
  { name: "Healthcare", color: "#F44336", description: "Medical expenses, insurance, pharmacy" },
  { name: "Salary", color: "#8BC34A", description: "Regular salary and wages" },
  { name: "Freelance", color: "#CDDC39", description: "Freelance and contract work income" },
  { name: "Investment", color: "#3F51B5", description: "Investment returns and dividends" },
  { name: "Rent/Mortgage", color: "#795548", description: "Housing payments" },
  { name: "Insurance", color: "#607D8B", description: "Insurance premiums" },
  { name: "Dining Out", color: "#FF5722", description: "Restaurants and takeout" },
  { name: "Shopping", color: "#E91E63", description: "Clothing and general shopping" },
  { name: "Education", color: "#009688", description: "Courses, books, training" },
  { name: "Travel", color: "#FF6F00", description: "Vacation and travel expenses" },
  { name: "Uncategorized", color: "#808080", description: "Default category for uncategorized transactions" }
]

categories.each do |category_attrs|
  Category.find_or_create_by!(name: category_attrs[:name]) do |category|
    category.color = category_attrs[:color]
    category.description = category_attrs[:description]
  end
end

puts "Created #{categories.length} default categories"

# Create sample account in development environment
if Rails.env.development?
  sample_account = Account.find_or_create_by!(name: "Sample Checking Account") do |account|
    account.account_type = "checking"
    account.account_number = "****1234"
    account.institution = "Sample Bank"
    account.current_balance = 2500.00
  end
  
  puts "Created sample account: #{sample_account.name}"
  
  # Create sample transactions
  groceries_category = Category.find_by(name: "Groceries")
  salary_category = Category.find_by(name: "Salary")
  utilities_category = Category.find_by(name: "Utilities")
  
  sample_transactions = [
    {
      account: sample_account,
      category: salary_category,
      amount: 3000.00,
      description: "Monthly Salary",
      transaction_date: 1.week.ago,
      transaction_type: "credit"
    },
    {
      account: sample_account,
      category: groceries_category,
      amount: -85.50,
      description: "Whole Foods Market",
      transaction_date: 2.days.ago,
      transaction_type: "debit"
    },
    {
      account: sample_account,
      category: utilities_category,
      amount: -120.00,
      description: "Electric Bill",
      transaction_date: 5.days.ago,
      transaction_type: "debit"
    }
  ]
  
  sample_transactions.each do |transaction_attrs|
    Transaction.find_or_create_by!(
      account: transaction_attrs[:account],
      description: transaction_attrs[:description],
      transaction_date: transaction_attrs[:transaction_date]
    ) do |transaction|
      transaction.category = transaction_attrs[:category]
      transaction.amount = transaction_attrs[:amount]
      transaction.transaction_type = transaction_attrs[:transaction_type]
    end
  end
  
  puts "Created #{sample_transactions.length} sample transactions"
end
