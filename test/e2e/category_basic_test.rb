require_relative "test_helper"

class CategoryBasicTest < E2ETestCase
  test "can view categories index" do
    visit "/categories"
    
    expect_heading("Categories")
    expect_text("Test Groceries")
    expect_text("Food and grocery shopping")
    expect_text("Add New Category")
  end
  
  test "can navigate to new category form" do
    visit "/categories"
    
    click_link "Add New Category"
    expect_heading("Add New Category")
    expect_text("Name")
    expect_text("Color")
    expect_text("Description")
  end
  
  test "category shows transaction count" do
    # Create a transaction with category
    Transaction.create!(
      description: "Grocery Shopping",
      amount: -85.00,
      transaction_date: Date.current,
      transaction_type: "debit",
      account: @test_account,
      category: @test_category
    )
    
    visit "/categories"
    
    expect_text("1 transaction")
  end
  
  test "can navigate to category form" do
    visit "/categories"
    
    # Test navigation to edit form
    first(:link, "Edit").click
    expect_heading("Edit Category")
    
    # Test cancel navigation
    click_link "Cancel"
    expect_heading("Categories")
  end
end