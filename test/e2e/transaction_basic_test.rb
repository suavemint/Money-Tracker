require_relative "test_helper"

class TransactionBasicTest < E2ETestCase
  test "can view transactions index" do
    visit "/transactions"

    expect_heading("Transactions")
    expect_text("Add New Transaction")
  end

  test "can navigate to new transaction form" do
    visit "/transactions"

    click_link "Add New Transaction"
    expect_heading("Add New Transaction")
    expect_text("Description")
    expect_text("Amount")
    expect_text("Transaction date")
    expect_text("Account")
  end

  test "can create transaction from account page" do
    visit "/accounts/#{@test_account.id}"

    expect_heading("Test Checking")
    expect_text("Add Transaction")

    click_link "Add Transaction"
    expect_heading("Add New Transaction")

    # Should show the account name since it's pre-selected
    expect_text("Test Checking")
  end

  test "shows transactions with proper formatting" do
    # Create test transactions (without category to avoid validation)
    Transaction.create!(
      description: "Income Test",
      amount: 1000.00,
      transaction_date: Date.current,
      transaction_type: "credit",
      account: @test_account
    )

    Transaction.create!(
      description: "Expense Test",
      amount: -50.00,
      transaction_date: Date.current,
      transaction_type: "debit",
      account: @test_account
    )

    visit "/transactions"

    expect_text("Income Test")
    expect_text("Expense Test")
    expect_text("+$1,000.00")
    expect_text("-$50.00")
  end
end
