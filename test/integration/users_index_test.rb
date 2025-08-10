require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:pietro)
    @nonAdmin = users(:michael)
  end

  test "index as admin including pagination and delete link" do
    log_in_as(@admin)
    get users_path
    assert_template "users/index"
    assert_select "div.pagination", count: 2
    assert_equal 10, assigns(:users).length

    users_per_page = 10
    expected_pages = (User.count / users_per_page.to_f).ceil
    assert_select "div.pagination a[href=?]", "/users?page=#{expected_pages}"

    first_page_of_users = User.paginate(page: 1, per_page: users_per_page)
    first_page_of_users.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @admin
        assert_select "a[href=?]", user_path(user), text: "delete"
      end
    end

    assert_difference "User.count", -1 do
      delete user_path(@nonAdmin)
      assert_response :see_other
      assert_redirected_to users_url
    end
  end

  test "index as non-admin" do
    log_in_as(@nonAdmin)
    get users_path
    assert_select "a", text: "delete", count: 0
  end
end
