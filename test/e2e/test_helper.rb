require "test_helper"
require "capybara/rails"
require "capybara/minitest"
require "selenium/webdriver"

class E2ETestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  def setup
    super
    setup_test_data
  end

  def setup_test_data
    # Clean up existing test data
    Account.where(name: "Test Checking").destroy_all
    Category.where(name: "Test Groceries").destroy_all

    # Create test data for our tests
    @test_account = Account.create!(
      name: "Test Checking",
      institution: "Test Bank",
      account_type: "checking",
      current_balance: 1500.00,
      account_number: "1234"
    )

    @test_category = Category.create!(
      name: "Test Groceries",
      color: "#4CAF50",
      description: "Food and grocery shopping"
    )
  end

  def expect_text(text)
    assert_text text
  end

  def expect_heading(text)
    assert_selector "h1, h2, h3", text: text
  end
end
