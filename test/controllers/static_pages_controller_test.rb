require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
# run before every test
  def setup
    @base_title = "Echo"
  end

  test "should get root page" do
    get root_url
    assert_response :success
    assert_select "title", "#{@base_title}"
  end
  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "#{@base_title} | Help"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "#{@base_title} | About"
  end
end
