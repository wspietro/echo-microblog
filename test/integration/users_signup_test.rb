require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      test_user_input = { name: "",
                          email: "user@invalid",
                          password: "foo",
                          password_confirmation: "bar" }
      post(users_path, params: { user: test_user_input })
    end

    assert_response :unprocessable_entity
    assert_template "users/new"
    assert_select "p.input-error-message"
    assert_select "p.input-error-message"
    assert_select "p", "Name can't be blank"
    assert_select "p", "Password is too short (minimum is 6 characters)"
    assert_select "p", "Password confirmation doesn't match Password"
  end
end
