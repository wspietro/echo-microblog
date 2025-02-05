require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:pietro)
  end

  test "login with invalid information" do
    get login_path

    test_login_input = { email: "invalid@email.com", password: "invalid" }
    post(login_path, params: { session: test_login_input })

    assert_template "sessions/new"
    assert_response :unprocessable_entity
    assert_select "div.alert-danger", "Invalid email/password combination."

    get root_path
    assert_select "div.alert-danger", { text: "Invalid email/password combination.", count: 0 }
  end

  test "login with valid email/invalid passowrd" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: @user.email,
                                         password: "invalid" } }
    assert_response :unprocessable_entity
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path

    test_login_input = { email: @user.email, password: "password" }
    post(login_path, params: { session: test_login_input })

    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!

    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", logout_path

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!

    assert_template "static_pages/home"
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
