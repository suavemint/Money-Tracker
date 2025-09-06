require "test_helper"

class StatementsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get statements_url
    assert_response :success
  end
end
