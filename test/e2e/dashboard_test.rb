require_relative "test_helper"

class DashboardTest < E2ETestCase
  test "dashboard displays correctly with test data" do
    visit "/"
    
    # Check that dashboard page loads
    expect_heading("Dashboard")
    
    # Check that total balance is displayed
    expect_text("Total Balance")
    expect_text("$1,500.00")
    
    # Check that accounts section exists
    expect_text("Accounts")
    expect_text("Test Checking")
    expect_text("Test Bank")
    
    # Check navigation links are present
    expect_text("Add Account")
    expect_text("Add Transaction")
    
    # Verify navigation menu
    expect_text("Money Tracker")
    expect_text("Dashboard")
    expect_text("Accounts")
    expect_text("Transactions")
    expect_text("Categories")
    expect_text("Statements")
  end
  
  test "dashboard navigation works correctly" do
    visit "/"
    
    # Test navigation to accounts
    click_link "Accounts"
    expect_heading("Accounts")
    
    # Navigate back to dashboard
    click_link "Dashboard"
    expect_heading("Dashboard")
    
    # Test navigation to transactions
    click_link "Transactions"
    expect_heading("Transactions")
    
    # Navigate back to dashboard
    click_link "Money Tracker"
    expect_heading("Dashboard")
  end
  
  test "quick action buttons work from dashboard" do
    visit "/"
    
    # Test Add Account button
    click_link "Add Account"
    expect_heading("Add New Account")
    
    # Go back to dashboard
    click_link "← Back to Accounts"
    click_link "Money Tracker"
    
    # Test Add Transaction button
    click_link "Add Transaction"
    expect_heading("Add New Transaction")
  end
end