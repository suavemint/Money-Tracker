require "test_helper"

class StatementsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get statements_index_url
    assert_response :success
  end

  test "should get show" do
    get statements_show_url
    assert_response :success
  end

  test "should get new" do
    get statements_new_url
    assert_response :success
  end

  test "should get create" do
    get statements_create_url
    assert_response :success
  end

  test "should get destroy" do
    get statements_destroy_url
    assert_response :success
  end
end
