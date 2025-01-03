require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "invalid login information" do
    get login_path

    test_login_input = { email: "invalid@email.com", password: "invalid" }
    post(login_path, params: { session: test_login_input })

    assert_template "sessions/new"
    assert_response :unprocessable_entity
    assert_select "div.alert-danger", "Invalid email/password combination."

    get root_path
    assert_select "div.alert-danger", { text: "Invalid email/password combination.", count: 0 }
  end
end
