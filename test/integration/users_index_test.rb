require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:pietro)
  end

  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template "users/index"
    assert_select "div.pagination", count: 2
    assert_equal 10, assigns(:users).length

    users_per_page = 10
    expected_pages = (User.count / users_per_page.to_f).ceil
    assert_select "div.pagination a[href=?]", "/users?page=#{expected_pages}"

    User.paginate(page: 1, per_page: users_per_page).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
  end
end
