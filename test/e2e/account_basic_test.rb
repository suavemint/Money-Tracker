require_relative "test_helper"

class AccountBasicTest < E2ETestCase
  test "can view accounts index" do
    visit "/accounts"

    expect_heading("Accounts")
    expect_text("Test Checking")
    expect_text("Test Bank")
    expect_text("$1,500.00")
    expect_text("Add New Account")
  end

  test "can navigate to new account form" do
    visit "/accounts"

    click_link "Add New Account"
    expect_heading("Add New Account")
    expect_text("Name")
    expect_text("Institution")
    expect_text("Account type")
    expect_text("Current balance")
  end

  test "can view account details" do
    visit "/accounts"

    click_link "Test Checking"
    expect_heading("Test Checking")
    expect_text("Test Bank")
    expect_text("Checking")
    expect_text("$1,500.00")
    expect_text("Add Transaction")
    expect_text("Upload Statement")
  end

  test "account navigation works" do
    visit "/accounts"

    # Go to account details
    click_link "Test Checking"
    expect_heading("Test Checking")

    # Go back to accounts list
    click_link "← Back to Accounts"
    expect_heading("Accounts")

    # Go to edit form (use first Edit link to avoid ambiguity)
    find(:link, "Edit", match: :first).click
    expect_heading("Edit Account")

    # Cancel back to account
    click_link "Cancel"
    expect_heading("Test Checking")
  end
end
